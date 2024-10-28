defmodule QuantumStorageEcto.ExecutionDates do
  alias QuantumStorageEcto.ExecutionDate
  require Logger

  @dialyzer [{:nowarn_function, upsert: 2}]

  @id "last_execution_date"

  @doc """
  Returns the last execution date as stored in the database
  """
  @spec get(repo :: module) :: NaiveDateTime.t() | nil
  def get(repo) do
    case ExecutionDate |> repo.get(@id) do
      nil -> :unknown
      %ExecutionDate{last_execution_date: date} -> date
    end
  end

  @doc """
  Gets the last execution date from the database and updates it with a new value

  ## Parameters
  - `value` - the new execution date
  - `repo` - the repo module that should be use to communicate with the database
  """
  @spec upsert(value :: NaiveDateTime.t(), repo :: module()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def upsert(value, repo) do
    Logger.debug(~c"updating last execution time to #{inspect(value)}")

    case ExecutionDate |> repo.get(@id) do
      nil ->
        %ExecutionDate{}
        |> ExecutionDate.changeset(%{id: @id, last_execution_date: value})
        |> repo.insert()

      current ->
        current
        |> ExecutionDate.changeset(%{last_execution_date: value})
        |> repo.update()
    end
  end
end
