defmodule Scraper.Mixfile do
  use Mix.Project

  def project do
    [app: :scraper,
     version: append_revision("0.1.0"),
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
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

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: app_list(),
     mod: {Scraper, []}]
  end

  defp app_list do
    [
      :httpoison,
      :hound,
      :logger,
      :quantum,
      :customer
    ]
  end

  # Specifies which paths to compile per environment.
  # defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  # defp elixirc_paths(_),     do: ["lib", "web"]


  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:floki, "~> 0.11.0"}, # parser
      {:hound, "~> 1.0"},
      {:httpoison, "~> 0.10.0", override: true},
      {:quantum, git: "https://github.com/c-rack/quantum-elixir" },
      {:customer, in_umbrella: true},
      {:edeliver, "~> 1.4.2"},
      {:distillery, ">= 0.8.0", warn_missing: false}
    ]
  end
end
