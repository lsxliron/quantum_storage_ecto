defmodule QuantumStorageEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :quantum_storage_ecto,
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.cobertura": :test
      ],
    name: "Quantum Storage Ecto",
    description: "Quantum Storage Adapter based on Ecto",
    source_url: "https://github.com/lsxliron/quantum_storage_ecto",
    homepage_url: "https://github.com/lsxliron/quantum_storage_ecto",
    docs: [
      main: "QuantumStorageEcto",
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.12"},
      {:ecto_sql, "~> 3.12"},
      {:quantum, "~> 3.0"},
      {:postgrex, ">= 0.0.0", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:makeup_html, ">= 0.0.0", only: :dev, runtime: false}

    ]
  end

  defp aliases() do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
    ]
  end
end
