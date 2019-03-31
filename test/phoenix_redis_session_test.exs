defmodule PhoenixRedisSessionTest do
  use ExUnit.Case
  doctest PhoenixRedisSession

  test "greets the world" do
    assert PhoenixRedisSession.hello() == :world
  end
end
