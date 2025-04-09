defmodule Lambdasword.MixProject do
  use Mix.Project

  def project do
    [
      app: :lambdasword,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger,:inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ollama, "~> 0.5.1"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.1"}
    ]
  end
end
