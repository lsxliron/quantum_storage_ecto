# QuantumStorageEcto

**Quantum Storage Adapter based on Ecto**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `quantum_storage_ecto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:quantum_storage_ecto, "~> 0.1.0"}
  ]
end
```

## How to Use?

Simply add QuantumStorageEcto in Quantum config.
You must provide the `Repo` module that should be used by the storage adapter

```elixir
config :my_app, MyApp.Scheduler,
  storage: QuantumStorageEcto,
  storage_opts: [
    repo: QuantumTestApp.Repo,
  ]
```

## Testing
To run the full test suite:
```sh
mix test
```