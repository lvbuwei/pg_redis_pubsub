-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION redis" to load this file. \quit

CREATE FUNCTION redis_status()
RETURNS text
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_connect()
RETURNS boolean
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_disconnect()
RETURNS boolean
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_publish(channel text, message text)
RETURNS int
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_lpush(channel text, message text)
RETURNS int
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_llen(channel text)
RETURNS int
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_sadd(channel text,message text)
RETURNS int
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_set(channel text,message text)
RETURNS TEXT
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_get(channel text)
RETURNS TEXT
AS '$libdir/redis'
LANGUAGE C;

CREATE FUNCTION redis_setex(channel text,timeout int,message text)
RETURNS TEXT
AS '$libdir/redis'
LANGUAGE C;


