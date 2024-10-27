defmodule QuantumStorageEcto.Migrations.AddJobsTable do
  use Ecto.Migration

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
  end

  def down do
    drop table(:quantum_jobs)
  end
end
