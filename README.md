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


Simply add `QuantumStorageEcto` in `Quantum` config and run the required migrations.

The `Repo` (`Ecto.Repo`) parameter is required and is used to communicate with the database

```elixir
config :my_app, MyApp.Scheduler,
  storage: QuantumStorageEcto,
  storage_opts: [
    repo: MyApp.Repo,
  ]
```

## Running the migrations

#### Create a new migration file in your application
```sh
mix ecto.gen.migration adding_quantum_storage_ecto
```

#### Edit the newly created migration file
```elixir
defmodule MyApp.Repo.Migrations.AddQuantumJobs do
  use Ecto.Migration
  
  def up do
  QuantumStorageEcto.Migrations.V1AddJobsTable.up()
  end
  
  def down do
  QuantumStorageEcto.Migrations.V1AddJobsTable.down()
  end
end
```
#### Migrate
```sh
mix ecto.migrate
```

## Testing
To run the full test suite:
```sh
mix test
```