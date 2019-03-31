defmodule PhoenixRedisSession do
  @moduledoc """
  Documentation for PhoenixRedisSession.
  runs as a worker for supervisor
  """
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: RedisServer)
  end

  def get(key) do
    GenServer.call(RedisServer, ["GET", key])
  end
    
  def setex(%{key: key, value: value, seconds: seconds}) do
    GenServer.call(RedisServer, ["SETEX", key, seconds, value])
  end
    
  def del(key) do
    GenServer.call(RedisServer, ["DEL", key])
  end
    
  def keys(pattern) do
    GenServer.call(RedisServer, ["KEYS", pattern])
  end
    
  @impl true
  def init(_opts) do
    {:ok, _conn} = Redix.start_link(
      Application.get_env(:redix, :redis, []))
  end
 
  @impl true
  def handle_call(cmd, _from, conn) do
    {:reply, redix_exec(cmd, conn), conn}
  end

  defp redix_exec(cmd, conn) do
    #case Redix.command(conn, cmd) do
    #  {:ok, result} -> result
    #  _ -> :undefined
    #end
    Redix.command(conn, cmd)
  end
end
