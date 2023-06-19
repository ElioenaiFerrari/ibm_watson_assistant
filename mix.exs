defmodule IbmWatsonAssistant.MixProject do
  use Mix.Project

  def project do
    [
      app: :ibm_watson_assistant,
      version: "1.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Module for handling IBM's Watson assistant",
      name: "IBM Watson Assistant",
      source_url: "https://github.com/ElioenaiFerrari/ibm_watson_assistant",
      package: [
        files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/ElioenaiFerrari/ibm_watson_assistant"}
      ],
      docs: [
        logo: "assets/logo.png",
        extras: ["README.md"]
      ]
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
      {:tesla, "~> 1.5"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.29.3", only: :dev, runtime: false}
    ]
  end
end
