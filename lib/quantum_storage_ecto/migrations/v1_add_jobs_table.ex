defmodule QuantumStorageEcto.Migrations.V1AddJobsTable do
  use Ecto.Migration
  @moduledoc false

  def up do
    create_if_not_exists table(:quantum_jobs, primary_key: false) do
      add :name, :string, primary_key: true
      add :overlap, :boolean
      add :run_strategy, :binary
      add :schedule, :map
      add :state, :string
      add :task, :binary
      add :timezone, :string

      timestamps()
    end

    create_if_not_exists table(:quantum_last_execution_date, primary_key: false) do
      add :id, :string, primary_key: true
      add :last_execution_date, :naive_datetime, null: true
    end
  end

  def down do
    drop table(:quantum_jobs)
    drop table(:quantum_last_execution_date)
  end
end
