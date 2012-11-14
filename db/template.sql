CREATE DATABASE template_sk_utf8_ci 
	WITH 
	  TEMPLATE      = template0 
	  ENCODING      = 'UNICODE'
	  LC_COLLATE    = 'sk_SK.utf8'
	  LC_CTYPE      = 'sk_SK.utf8';

UPDATE pg_database SET datistemplate = true WHERE datname = 'template_sk_utf8_ci';
