defmodule PhoenixRedisSession.MixProject do
  use Mix.Project

  @description"""
  The Redis Session adapter for the Phoenix.
  """
  
  def project do
    [
      app: :phoenix_redis_session,
      version: "0.1.1",
      elixir: "~> 1.8",
      name: "PhoenixRedisSession",
      description: @description,
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def package do
    [
      maintainers: ["Katsuyoshi Yabe"],
      licenses: ["MIT"],
      links: %{ "Github": "https://github.com/kay1759/phoenix_redis_session" }
    ]
  end
  
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PhoenixRedisSession.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:redix, ">= 0.0.0"},
      {:ex_doc, "~> 0.24.2", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end
end
