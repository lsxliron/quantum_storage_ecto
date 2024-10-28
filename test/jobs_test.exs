defmodule QuantumStorageEcto.JobsTest do
  use ExUnit.Case, async: true
  use QuantumStorageEcto.DataCase
  import Crontab.CronExpression
  alias QuantumStorageEcto.Repo
  import QuantumStorageEcto.Fixtures

  describe "insert/2" do
    test "can insert jobs successfully" do
      assert {:ok, nameless_job} =
               test_job() |> Map.from_struct() |> QuantumStorageEcto.Jobs.insert(Repo)

      assert nameless_job.name |> is_reference()

      assert {:ok, named_job} =
               test_job(name: :test) |> Map.from_struct() |> QuantumStorageEcto.Jobs.insert(Repo)

      assert named_job.name == :test
    end

    test "should fail to insert incomplete jobs" do
      assert {:error, changeset} =
               test_job()
               |> Map.from_struct()
               |> Map.drop([:schedule])
               |> QuantumStorageEcto.Jobs.insert(Repo)

      assert changeset |> errors_on() == %{schedule: ["can't be blank"]}
    end
  end

  describe "delete/2" do
    test "can delete a job" do
      assert {:ok, named_job} =
               test_job() |> Map.from_struct() |> QuantumStorageEcto.Jobs.insert(Repo)

      {:ok, deleted_job} = QuantumStorageEcto.Jobs.delete_job_by_name(named_job.name, Repo)
      assert Map.drop(named_job, [:__meta__]) == Map.drop(deleted_job, [:__meta__])
    end
  end

  test "returns a proper error if job does not exists" do
    {:error, "job does not exists"} = QuantumStorageEcto.Jobs.delete_job_by_name(make_ref(), Repo)
    {:error, "job does not exists"} = QuantumStorageEcto.Jobs.delete(nil, Repo)
  end

  describe "get_all/1" do
    test "can get all the jobs" do
      store_n_jobs(3)
      assert QuantumStorageEcto.Jobs.get_all(Repo) |> length == 3
    end
  end

  describe "purge/1" do
    test "can delete all jobs" do
      store_n_jobs(3)
      assert QuantumStorageEcto.Jobs.get_all(Repo) |> length == 3
      Repo |> QuantumStorageEcto.Jobs.delete_all()
      assert QuantumStorageEcto.Jobs.get_all(Repo) |> length == 0
    end
  end

  describe "full_update/2" do
    test "can make a full update to an existing job" do
      {:ok, job} =
        test_job() |> Map.from_struct() |> QuantumStorageEcto.Jobs.insert(Repo)

      job
      |> Map.put(:schedule, ~e[* * * * 1])
      |> QuantumStorageEcto.Jobs.full_update(Repo)

      updated_job = QuantumStorageEcto.Job |> Repo.get(job.name)
      assert Map.drop(job, [:schedule]) == Map.drop(updated_job, [:schedule])
      assert updated_job.schedule == ~e[* * * * 1]
    end

    test "returns a proper error if a job does not exists" do
      {:ok, job} =
        test_job() |> Map.from_struct() |> QuantumStorageEcto.Jobs.insert(Repo)

      {:error, reason} =
        job
        |> Map.put(:name, make_ref())
        |> QuantumStorageEcto.Jobs.full_update(Repo)

      assert reason =~ "does not exists"
    end
  end

  describe "update/2" do
    test "can perform partial update successfully" do
      {:ok, job} =
        test_job() |> Map.from_struct() |> QuantumStorageEcto.Jobs.insert(Repo)

      attrs = %{schedule: ~e[* * * * 2], task: fn -> :ok end}
      QuantumStorageEcto.Jobs.update(job.name, attrs, Repo)
      updated_job = QuantumStorageEcto.Job |> Repo.get(job.name)
      assert job.name == updated_job.name
      assert job.schedule == ~e[* * * * *]
      assert updated_job.schedule == ~e[* * * * 2]
    end
  end
end
