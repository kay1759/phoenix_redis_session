# PhoenixRedisSession

The Redis Session adapter for the Phoenix.

Based on [Thoughtbot/Redbird](https://hex.pm/packages/redbird), change to use [Redix](https://hex.pm/packages/redix).

## Installation

The package can be installed by adding `:phoenix_redis_session` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_redis_session, "~> 0.1.2"}
  ]
end
```

## Configuration

### Redix
```elixir
config :redix, :redis,
  host: "localhost",
  port: 6379,
  database: 0,
  name: :session
```

### Session key_namespace
All redbird created keys are automatically namespaced with "session_" by default. If you'd like to set your own custom, per app, configuration you can set that in the config.
```elixir
config :phoenix_redis_session, :key_namespace, "redis_session_"
```

### Plug
```elixir
plug Plug.Session,
  store: :redis,
  key: "_app_key",
  expiration_in_seconds: 3000 # Optional - default is 30 days
```

## Environment:
Latest environment is as below.

* Arch Linux version 5.19.11-arch1-1
* Erlang 25.0
* Elixir 1.14.1


Programing environment is as below.

* Ubuntu 18.04.1 LTS
* Erlang 21.2
* Elixir 1.8.1


## References:
- [Hex redbird](https://hex.pm/packages/redbird)
- [Hex redix](https://hex.pm/packages/redix)

## Licence:

[MIT]

## Author

[Katsuyoshi Yabe](https://github.com/kay1759)

