defmodule AshStripe.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/alemoreau/ash_stripe"

  def project do
    [
      app: :ash_stripe,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ash, "~> 3.0"},
      {:req, "~> 0.4"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      name: "ash_stripe",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp description do
    "An Ash extension for integrating Stripe with your Ash applications"
  end
end