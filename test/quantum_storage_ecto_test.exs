defmodule QuantumStorageEctoTest do
  use ExUnit.Case, async: false
  use QuantumStorageEcto.DataCase
  import QuantumStorageEcto.Fixtures
  import Crontab.CronExpression
  alias QuantumStorageEcto.Repo
  alias QuantumStorageEcto.TestScheduler

  setup _ do
    pid = start_supervised!({TestScheduler, [repo: Repo]})

    {:ok, %{scheduler: pid}}
  end

  test "can add jobs" do
    named_job = test_job()
    nameless_job = test_job(name: :test_job)
    TestScheduler.add_job(named_job)
    TestScheduler.add_job(nameless_job)
    refute TestScheduler.find_job(named_job.name) |> is_nil()
    refute TestScheduler.find_job(nameless_job.name) |> is_nil()
    Process.sleep(100)
  end

  test "can delete a job properly" do
    job = test_job()
    TestScheduler.add_job(job)
    refute TestScheduler.find_job(job.name) |> is_nil()
    TestScheduler.delete_job(job.name)
    refute TestScheduler.find_job(job.name)
    Process.sleep(100)
  end

  test "can delete all jobs" do
    test_job()
    |> TestScheduler.add_job()

    assert TestScheduler.jobs() |> length == 1
    assert TestScheduler.delete_all_jobs()
    assert TestScheduler.jobs() |> length == 0
    Process.sleep(100)
  end

  test "can update job successfully" do
    job = test_job()
    job |> TestScheduler.add_job()

    TestScheduler.find_job(job.name)
    |> Quantum.Job.set_schedule(~e[* * * * 3])
    |> TestScheduler.add_job()

    assert TestScheduler.find_job(job.name) |> Map.get(:schedule) == ~e[* * * * 3]
    Process.sleep(100)
  end

  test "can toggle job states" do
    job = test_job()
    job |> TestScheduler.add_job()

    assert TestScheduler.find_job(job.name) |> Map.get(:state) == :active
    TestScheduler.deactivate_job(job.name)
    assert TestScheduler.find_job(job.name) |> Map.get(:state) == :inactive
    Process.sleep(100)
  end

  test "can get last execution time without one set" do
    assert GenServer.call(QuantumStorageEcto.TestScheduler.Storage, :last_execution_date) ==
             :unknown

    expected_date = NaiveDateTime.utc_now()

    GenServer.cast(
      QuantumStorageEcto.TestScheduler.Storage,
      {:update_last_execution_date, expected_date}
    )

    assert GenServer.call(QuantumStorageEcto.TestScheduler.Storage, :last_execution_date) ==
             expected_date |> NaiveDateTime.truncate(:second)

    Process.sleep(100)
  end
end
