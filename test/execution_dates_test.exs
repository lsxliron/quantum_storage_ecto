defmodule QuantumStorageEcto.ExecutionDatesTest do
  use ExUnit.Case, async: true
  use QuantumStorageEcto.DataCase
  alias QuantumStorageEcto.Repo
  alias QuantumStorageEcto.ExecutionDates

  describe "get/1" do
    test "returns a proper value is date is not set yet" do
      assert ExecutionDates.get(Repo) == :unknown
    end

    test "can retrieve a value form the database" do
      expected_date = NaiveDateTime.utc_now()

      %QuantumStorageEcto.ExecutionDate{}
      |> QuantumStorageEcto.ExecutionDate.changeset(%{
        last_execution_date: expected_date,
        id: "last_execution_date"
      })
      |> Repo.insert()

      assert ExecutionDates.get(Repo) == expected_date |> NaiveDateTime.truncate(:second)
    end
  end

  describe "upsert/2" do
    test "can update the existing execution date successfully" do
      expected_date = NaiveDateTime.utc_now()

      %QuantumStorageEcto.ExecutionDate{}
      |> QuantumStorageEcto.ExecutionDate.changeset(%{
        last_execution_date: expected_date,
        id: "last_execution_date"
      })
      |> Repo.insert()

      updated = expected_date |> NaiveDateTime.add(1, :day)
      {:ok, _} = ExecutionDates.upsert(updated, Repo)
      assert assert ExecutionDates.get(Repo) == updated |> NaiveDateTime.truncate(:second)
    end

    test "can update the existing execution date when one does not exist" do
      expected_date = NaiveDateTime.utc_now()
      assert ExecutionDates.get(Repo) == :unknown

      {:ok, _} = ExecutionDates.upsert(expected_date, Repo)
      assert assert ExecutionDates.get(Repo) == expected_date |> NaiveDateTime.truncate(:second)
    end
  end
end
