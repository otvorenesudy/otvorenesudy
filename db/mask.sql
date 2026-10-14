-- Masks personal data in a local copy of the production database. bin/restore-production-copy runs it straight after
-- the restore; to run it by hand:
--
--   psql -d opencourts_development -v keep_email=you@example.com -f db/mask.sql
--
-- Every user except the one with keep_email gets the e-mail user<id>@example.invalid, the password "password" and no
-- confirmation, reset or remember tokens; their subscriptions get new random unsubscribe tokens, as the app makes
-- them. They lose admin rights too: with a known password, anyone who reaches the local app could sign in as one.
-- Ids, confirmation state and subscriptions stay, so the app behaves as in production. Running it again only draws
-- the masked subscriptions' tokens anew, and fixes a copy masked before admins were or with tokens derived from ids.

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE kept_users ON COMMIT DROP AS
SELECT id FROM public.users WHERE lower(email) = lower(:'keep_email');

CREATE TEMP TABLE mask_state ON COMMIT DROP AS
SELECT NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto') AS created_pgcrypto;

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

-- One hash for everyone: bcrypt with cost 10 is what Devise uses, and hashing per row would take minutes.
CREATE TEMP TABLE masked_password ON COMMIT DROP AS
SELECT public.crypt('password', public.gen_salt('bf', 10)) AS hash;

UPDATE public.users AS u
SET email = 'user' || u.id || '@example.invalid',
    unconfirmed_email = NULL,
    encrypted_password = p.hash,
    confirmation_token = NULL,
    reset_password_token = NULL,
    reset_password_sent_at = NULL,
    remember_created_at = NULL
FROM masked_password AS p
WHERE u.id NOT IN (SELECT id FROM kept_users)
  AND u.email <> 'user' || u.id || '@example.invalid';

UPDATE public.users
SET admin = false
WHERE id NOT IN (SELECT id FROM kept_users)
  AND admin;

-- subscriptions.token exists once migration 20260423120000 has run. A token is 24 random bytes in URL-safe Base64,
-- 32 characters, like SecureRandom.urlsafe_base64(24) in Subscription.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'subscriptions' AND column_name = 'token'
  ) THEN
    EXECUTE $sql$
      UPDATE public.subscriptions
      SET token = translate(encode(public.gen_random_bytes(24), 'base64'), '+/', '-_')
      WHERE user_id NOT IN (SELECT id FROM kept_users)
    $sql$;
  END IF;
END
$$;

DO $$
DECLARE
  leaked integer;
BEGIN
  SELECT count(*) INTO leaked
  FROM public.users
  WHERE id NOT IN (SELECT id FROM kept_users) AND email NOT LIKE '%@example.invalid';

  IF leaked > 0 THEN
    RAISE EXCEPTION 'mask.sql: % users still have their real e-mail', leaked;
  END IF;
END
$$;

DO $$
BEGIN
  IF (SELECT created_pgcrypto FROM mask_state) THEN
    DROP EXTENSION pgcrypto;
  END IF;
END
$$;

SELECT
  (SELECT count(*) FROM public.users) AS users,
  (SELECT count(*) FROM public.users WHERE email LIKE '%@example.invalid') AS masked_users,
  (SELECT count(*) FROM kept_users) AS kept_users,
  (SELECT count(*) FROM public.users WHERE admin) AS admins,
  (SELECT count(*) FROM public.subscriptions) AS subscriptions,
  (SELECT count(*) FROM public.subscriptions WHERE user_id IN (SELECT id FROM kept_users)) AS kept_subscriptions;

COMMIT;
