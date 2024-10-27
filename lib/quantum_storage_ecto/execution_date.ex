defmodule QuantumStorageEcto.ExecutionDate do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  A model that for a single date value
  """

  @primary_key false
  schema "quantum_last_execution_date" do
    field :id, :string, primary_key: true
    field :last_execution_date, :naive_datetime
  end

  def changeset(date, attrs \\ %{}) do
    date
    |> cast(attrs, [:id, :last_execution_date])
    |> validate_required([:id])
  end
end
