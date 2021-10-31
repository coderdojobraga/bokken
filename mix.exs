defmodule Bokken.MixProject do
  use Mix.Project

  @version "0.2.0-dev"
  @description "Backend platform for managing session registrations and recording ninjas' progress for CoderDojo Braga"

  def project do
    [
      app: :bokken,
      version: @version,
      description: @description,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bokken.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.0"},

      # database
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"},

      # monitoring
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.5"},

      # utilities
      {:plug_cowboy, "~> 2.5"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:browser, "~> 0.4.4"},
      {:corsica, "~> 1.1"},
      {:dotenvy, "~> 0.5.0"},

      # security
      {:guardian, "~> 2.2"},
      {:argon2_elixir, "~> 2.4"},

      # uploads
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0"},

      # mailer
      {:swoosh, "~> 1.5"},
      {:phoenix_swoosh, "~> 1.0"},

      # admin panel
      {:phoenix_html, "~> 2.11", override: true},
      {:kaffy, "~> 0.9.0", override: true},

      # tools
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
