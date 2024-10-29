defmodule QuantumStorageEcto.Types.AtomOrRefTest do
  use ExUnit.Case, async: true
  use QuantumStorageEcto.DataCase
  import Crontab.CronExpression
  alias QuantumStorageEcto.Job
  alias QuantumStorageEcto.Repo

  setup _ do
    params = %{
      schedule: ~e[1 * * * *],
      task: fn -> :ok end,
      run_strategy: %Quantum.RunStrategy.Local{}
    }

    {:ok, %{params: params}}
  end

  def validate(attrs) do
    {:ok, _} =
      %Job{}
      |> Job.changeset(attrs)
      |> QuantumStorageEcto.Repo.insert()

    refute Job |> Repo.get(attrs.name) |> is_nil()
  end

  test "can store atom properly", %{params: attrs} do
    attrs |> Map.put(:name, :test_job_reference) |> validate()
  end

  test "can store string properly", %{params: attrs} do
    attrs |> Map.put(:name, "test_job_reference") |> validate()
  end

  test "can store reference properly", %{params: attrs} do
    attrs |> Map.put(:name, make_ref()) |> validate()
  end

  test "can store string reference properly", %{params: attrs} do
    attrs |> Map.put(:name, "#Reference<0.946883141.702808066.133335>") |> validate()
  end
end
