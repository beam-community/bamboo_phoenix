defmodule BambooPhoenix.MixProject do
  use Mix.Project

  @project_url "https://github.com/thoughtbot/bamboo_phoenix"
  @version "1.0.0"

  def project do
    [
      app: :bamboo_phoenix,
      version: @version,
      elixir: "~> 1.8",
      source_url: @project_url,
      homepage_url: @project_url,
      start_permanent: Mix.env() == :prod,
      description: "Use Phoenix to rendering your Bamboo emails",
      package: package(),
      docs: [main: "readme", extras: ["README.md"]],
      deps: deps()
    ]
  end

  defp package do
    [
      maintainers: ["German Velasco"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bamboo, ">= 2.0.0"},
      {:phoenix, ">= 1.7.0"},
      {:phoenix_html, "~> 3.0", only: :test},
      {:phoenix_live_view, "~> 0.18", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
