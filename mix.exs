defmodule BambooPhoenix.MixProject do
  use Mix.Project

  @project_url "https://github.com/thoughtbot/bamboo_phoenix"
  @version "1.0.0"

  def project do
    [
      app: :bamboo_phoenix,
      version: @version,
      elixir: "~> 1.12",
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
      {:bamboo, ">= 2.2.0"},
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.1", only: :test},
      {:ex_doc, "~> 0.20", only: :dev, runtime: false}
    ]
  end
end
