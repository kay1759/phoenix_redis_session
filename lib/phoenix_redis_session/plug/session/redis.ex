defmodule Plug.Session.REDIS do
  require IEx

  @moduledoc """
  Stores the session in a redis store.
  """

  @behaviour Plug.Session.Store
  @default_namespace "session_"
  @max_session_time 86_164 * 30

  def init(opts) do
    opts
  end

  def get(_conn, namespaced_key, _init_options) do
    case PhoenixRedisSession.get(namespaced_key) do
      {:ok, nil} -> {nil, %{}}
      {:ok, result} ->
        {:ok, decoded} = result |> Poison.decode()
        {namespaced_key, decoded}
      _ -> {nil, %{}}
    end
  end

  def put(conn, nil, data, init_options) do
    put(conn, add_namespace(generate_random_key()), data, init_options)
  end

  def put(_conn, namespaced_key, data, init_options) do
    set_key_with_retries(
      namespaced_key,
      data,
      session_expiration(init_options),
      1
    )
  end

  defp set_key_with_retries(key, data, seconds, counter) do
    {:ok, json} = Poison.encode(data)
    case PhoenixRedisSession.setex(%{key: key, value: json, seconds: seconds}) do
      {:ok, _result} ->
        key

      response ->
        {:ok, reason} = response |> elem(1) |> Poison.encode()
        if counter > 5 do
          Redis.RedisError.raise(error: reason, key: key)
        else
          set_key_with_retries(key, data, seconds, counter + 1)
        end
    end
  end

  def delete(_conn, redis_key, _init_options) do
    case PhoenixRedisSession.del(redis_key) do
      {:ok, _result} -> :ok
      response -> elem(response, 0)
    end
  end

  defp add_namespace(key) do
    namespace() <> key
  end

  def namespace do
    Application.get_env(:phoenix_redis_session, :key_namespace, @default_namespace)
  end

  defp generate_random_key do
    :crypto.strong_rand_bytes(96) |> Base.encode64()
  end

  defp session_expiration(opts) do
    case opts[:expiration_in_seconds] do
      seconds when is_integer(seconds) -> seconds
      _ -> @max_session_time
    end
  end
end

defmodule Redis.RedisError do
  defexception [:message]
  @base_message "Redis Session was unable to store the session in redis."

  def raise(error: error, key: key) do
    message = "#{@base_message} Redis Error: #{error} key: #{key}"
    raise __MODULE__, message
  end

  def exception(message) do
    %__MODULE__{message: message}
  end
end
