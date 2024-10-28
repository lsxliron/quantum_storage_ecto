defmodule QuantumStorageEcto.Fixtures do
  import Crontab.CronExpression
  alias QuantumStorageEcto.Repo

  def test_job(opts \\ []) do
    schedule = Keyword.get(opts, :schedule, ~e[* * * * *])
    name = Keyword.get(opts, :name, make_ref())
    task = Keyword.get(opts, :task, fn -> IO.puts("A") end)

    QuantumStorageEcto.TestScheduler.new_job()
    |> Quantum.Job.set_schedule(schedule)
    |> Quantum.Job.set_name(name)
    |> Quantum.Job.set_task(task)
  end

  def store_n_jobs(n) do
    0..(n - 1)
    |> Enum.map(fn _ ->
      test_job()
      |> Map.from_struct()
      |> QuantumStorageEcto.Jobs.insert(Repo)
    end)
  end
end
