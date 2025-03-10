# QuantumStorageEcto

[![Coverage Status](https://coveralls.io/repos/github/lsxliron/quantum_storage_ecto/badge.svg?branch=master)](https://coveralls.io/github/lsxliron/quantum_storage_ecto?branch=master)
[![Hex.pm Version](http://img.shields.io/hexpm/v/quantum_storage_ecto.svg)](https://hex.pm/packages/quantum_storage_ecto)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/quantum_storage_ecto)
[![Hex.pm](https://img.shields.io/hexpm/dt/quantum_storage_ecto.svg)](https://hex.pm/packages/quantum_storage_ecto)

**Quantum Storage Adapter based on Ecto**

## Installation

The package can be installed by adding `quantum_storage_ecto` to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:quantum_storage_ecto, "~> 0.2"}
  ]
end
```

## Upgrading from 0.1

Create a mew migration file with the following content:

```elixir
defmodule MyApp.Repo.Migrations.AddIdToQuantumJobs do
  use Ecto.Migration

  def up do
    QuantumStorageEcto.Migrations.V2AddIdToJob.up()
  end

  def down do
    QuantumStorageEcto.Migrations.V2AddIdToJob.down()
  end
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

## Upgrading from 0.1

Create a mew migration file with the following content:

```elixir
defmodule MyApp.Repo.Migrations.AddIdToQuantumJobs do
  use Ecto.Migration

  def up do
    QuantumStorageEcto.Migrations.V2AddIdToJob.up()
  end

  def down do
    QuantumStorageEcto.Migrations.V2AddIdToJob.down()
  end
end
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
    QuantumStorageEcto.Migrations.V2AddIdToJob.up()
  end

  def down do
    QuantumStorageEcto.Migrations.V1AddJobsTable.down()
    QuantumStorageEcto.Migrations.V2AddIdToJob.down()
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

