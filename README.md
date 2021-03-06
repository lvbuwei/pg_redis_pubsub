# 增加了一些函数

因为原作者写的扩展只有pub和sub两个功能，在使用的过程中，感觉不够，因此fock了原作者的代码，在此基本上增加了自己需要的函数。
在此，感谢非常原作者的贡献。

增加的函数,可以看redis.sql文件。


# Redis Publish PostgreSQL Extension

This PostgreSQL extension allows you to connect to Redis and publish messages on a Redis channel from PostgreSQL.

## Requirements

To build you must have:

- PostgreSQL 9.1+
- HIREDIS C Client

#### HIREDIS

The [HIREDIS C client library](https://github.com/redis/hiredis) is a minimalistic C client library for the Redis database.

On Ubuntu 12.04+, it can be installed using the apt-get package [libhiredis-dev](https://launchpad.net/ubuntu/+source/hiredis).

```sh
sudo apt-get install libhiredis-dev
```

## Installation

This code is a standard PostgreSQL extension so all you need to run is:

```sh
make clean install
```

And then in the database:

```sql
CREATE EXTENSION redis;
```

## Settings

Settings can be specified globally (using **postgresql.conf** or **ALTER SYSTEM ... SET**),
at the database level (using **ALTER DATABASE ... SET**), or at the role level
(using ALTER ROLE ... SET).

* **redis.host** - Redis client host setting.
* **redis.port** - Redis client port setting.

## Usage

**redis_status**()

Returns the status of the Redis client.

**redis_connect**()

Connects the Redis client using the **redis.host** and **redis.port** configuratin settings.

**redis_disconnect**()

Disconnects the Redis client.

**redis_publish**(*channel* text, *message* text)

Publishes a message on the channel provided.

If the Redis client is not currently connected, it will first create a new connection before attempting to publish the message.

## Roadmap

- Return record with columns host text, port int, connected boolean.
- Add a set of Redis connections to use?
- Add subscribe and psubscribe support that executes a PostgreSQL function?

## Examples

### Basic Example

```sql
CREATE EXTENSION IF NOT EXISTS redis;

SELECT redis_connect();

SELECT redis_publish('mychannel', 'Hello World');

SELECT redis_disconnect();
```

### Trigger Example

```sql
CREATE EXTENSION IF NOT EXISTS redis;

CREATE TABLE IF NOT EXISTS products (
    id serial,
    name varchar(255)
);

CREATE OR REPLACE FUNCTION after_change()
    RETURNS TRIGGER AS
    $$
        DECLARE
            channel text;
            message json;
        BEGIN
            channel = 'products:' || NEW.id::text;
            message = to_jsonb(NEW);

            PERFORM redis_publish('products:, message::text);
            RETURN NULL;
        END;
    $$
    LANGUAGE plpgsql;

CREATE TRIGGER products_after_change
    AFTER INSERT OR UPDATE ON products
    FOR EACH ROW
    EXECUTE PROCEDURE after_change();

INSERT INTO products (name) VALUES ('Ale'), ('Beer'), ('Cider');
```
