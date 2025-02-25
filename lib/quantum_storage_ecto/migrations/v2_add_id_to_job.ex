defmodule QuantumStorageEcto.Migrations.V2AddIdToJob do
  use Ecto.Migration

  def up do
    alter table(:quantum_jobs) do
      add :id, :binary, null: false
    end
  end

  def down do
    alter table(:quantum_jobs) do
      remove :id
    end
  end
end
