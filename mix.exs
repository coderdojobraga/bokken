defmodule Bokken.MixProject do
  use Mix.Project

  @app :bokken
  @name "Bokken"
  @version "1.0.6-#{Mix.env()}"
  @description "Backend platform for managing session registrations and recording ninjas' progress for CoderDojo Braga"

  def project do
    [
      app: @app,
      name: @name,
      version: @version,
      description: @description,
      git_ref: git_revision_hash(),
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() in [:prod, :stg],
      deps: deps(),
      docs: docs(),
      aliases: aliases(),
      preferred_cli_env: [
        check: :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bokken.Application, []},
      extra_applications: [:inets, :logger, :runtime_tools, :os_mon]
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

      # security
      {:guardian, "~> 2.2"},
      {:argon2_elixir, "~> 3.0"},

      # uploads
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0"},

      # mailer
      {:swoosh, "~> 1.5"},
      {:phoenix_swoosh, "~> 1.0"},
      {:hackney, "~> 1.18"},

      # plugs
      {:plug_cowboy, "~> 2.5"},
      {:cors_plug, "~> 3.0"},

      # utilities
      {:gettext, "~> 0.22.1"},
      {:jason, "~> 1.3"},
      {:browser, "~> 0.5.1"},
      {:timex, "~> 3.7.9"},
      {:ex_phone_number, "~> 0.3"},

      # monitoring
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.5"},

      # admin panel
      {:phoenix_html, "~> 2.11", override: true},
      {:kaffy, "~> 0.9.0", override: true},

      # development
      {:dotenvy, "~> 0.7.0"},

      # testing
      {:faker, "~> 0.17", only: [:dev, :test]},
      {:ex_machina, "~> 2.7.0"},

      # tools
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28", only: [:dev], runtime: false}
    ]
  end

  # To generate documentation use:
  #
  #     $ mix docs
  defp docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      logo: "priv/static/images/logo.svg",
      source_url: "https://github.com/coderdojobraga/bokken",
      extras: extras()
    ]
  end

  defp extras do
    [
      {:"README.md", [title: "⚔️ Overview"]},
      {:"CONTRIBUTING.md", [title: "🚀 Getting Started"]}
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
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      lint: ["credo --strict --all"],
      check: [
        "clean",
        "deps.unlock --check-unused",
        "compile --warnings-as-errors",
        "format --check-formatted",
        "deps.unlock --check-unused",
        "test --warnings-as-errors",
        "lint"
      ]
    ]
  end

  defp git_revision_hash do
    case System.cmd("git", ["rev-parse", "HEAD"]) do
      {ref, 0} ->
        ref

      {_, _code} ->
        git_ref = File.read!(".git/HEAD")

        if String.contains?(git_ref, "ref:") do
          ["ref:", ref_path] = String.split(git_ref)
          File.read!(".git/#{ref_path}")
        else
          git_ref
        end
    end
    |> String.replace("\n", "")
  end
end
