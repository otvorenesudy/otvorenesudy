# frozen_string_literal: true

# Unsubscribe links in e-mails sent before October 2026 carry the token in the path
# (/subscriptions/unsubscribe/<token>), which the logs show in full. This moves it to the query string, which they
# filter (filter_parameters: token), before anything logs the request.
class LegacyUnsubscribeLinks
  PATH = %r{\A/subscriptions/unsubscribe/([^/]+)\z}

  def initialize(app)
    @app = app
  end

  def call(env)
    match = PATH.match(env['PATH_INFO'].to_s)

    rewrite(env, Rack::Utils.unescape_path(match[1])) if match

    @app.call(env)
  end

  private

  def rewrite(env, token)
    query = [env['QUERY_STRING'].presence, Rack::Utils.build_query('token' => token)].compact.join('&')
    path = '/subscriptions/unsubscribe'

    env['PATH_INFO'] = path
    env['QUERY_STRING'] = query
    env['REQUEST_URI'] = env['ORIGINAL_FULLPATH'] = "#{path}?#{query}"
  end
end

Rails.application.config.middleware.insert_before Rails::Rack::Logger, LegacyUnsubscribeLinks
