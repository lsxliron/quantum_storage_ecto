defmodule QuantumStorageEcto.ExecutionDate do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  A model that for a single date value
  """

  @type t :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: String.t(),
          last_execution_date: NaiveDateTime.t()
        }

  @primary_key false
  schema "quantum_last_execution_date" do
    field :id, :string, primary_key: true
    field :last_execution_date, :naive_datetime
  end

  @spec changeset(date :: t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(date, attrs \\ %{}) do
    date
    |> cast(attrs, [:id, :last_execution_date])
    |> validate_required([:id])
  end
end
