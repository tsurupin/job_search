defmodule Customer.Mixfile do
  use Mix.Project

  def project do
    [app: :customer,
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     version: append_revision("0.1.4"),
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  def append_revision(version) do
     "#{version}+#{revision()}"
  end

  defp revision() do
    System.cmd("git", ["rev-parse", "--short", "HEAD"])
    |> elem(0)
    |> String.rstrip
  end
  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.

  def application do
    [mod: {Customer, []}, extra_applications: [:logger]]
  end
  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0-rc", override: true},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:good_times, "~> 1.1"}, # extended wrapper for time
     {:cowboy, "~> 1.0"},
     {:dialyxir, "~> 0.3", only: :dev},
     {:envy, "~> 0.0.1"}, # env settings
     {:pact, "0.1.0"},
     {:ex_machina, "~> 1.0"}, # factory for elixir
     {:exgravatar, "~> 0.2", only: :dev}, # dummy image url
     {:csv, "~> 1.4.2"},
     {:ueberauth_google, "~> 0.4"},
     {:arc, "~> 0.6.0-rc3"}, # carrierwave for elixir
     {:ex_aws, "~> 1.0.0-rc3"},
     {:poison, "~> 2.0"},
     {:sweet_xml, "~> 0.5"},
     {:secure_random, "~> 0.1"},
     {:scrivener_ecto, git: "https://github.com/drewolson/scrivener_ecto"},
     {:timex, "~> 3.0"},
     {:timex_ecto, "~> 3.0"},
     {:guardian, "~> 0.14.0"},
     {:guardian_db, "~> 0.7"},
     {:tirexs, "~> 0.8"}, # for elastic search,
     {:exsentry, "~> 0.7"}, # error report,
     {:credo, "~> 0.5", only: [:dev, :test]} # rubocop for elixir
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup.sh
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": [ "ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
