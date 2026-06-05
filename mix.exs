defmodule ForgeMasterBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :forge_master_bot,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ForgeMasterBot.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nostrum, github: "Kraigie/nostrum"},
      {:quantum, "~> 3.5"},
      {:yaml_elixir, "~> 2.9"},
      {:tzdata, "~> 1.1"}
    ]
  end
end
