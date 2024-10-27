defmodule QuantumStorageEcto.Server do
  use GenServer
  require Logger
  alias QuantumStorageEcto.Jobs

  @moduledoc """
  This GenServer is an implementation fo `Quantum.Storage` and contains
  all the required functions to store Quantum jobs using Ecto
  """

  @doc """
  Start the GenServer
  The required `opts` parameters are `repo` which contains the Ecto Repo
  to communicate with the database
  """
  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    Logger.info("starting QuantumStorageEcto with opts #{inspect(opts)}")
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl GenServer
  def init(opts) do
    repo = Keyword.get(opts, :repo)
    {:ok, %{repo: repo, last_execution_time: DateTime.utc_now()}}
  end

  @impl GenServer
  def handle_cast({:add_job, job}, %{repo: repo} = state) do
    Logger.info("storing #{inspect(job)}")

    with {:ok, stored_job} <- job |> Map.from_struct() |> Jobs.insert(repo) do
      Logger.info("job stored successfully")
      Logger.debug(inspect(stored_job))
    else
      {:error, changeset} ->
        Logger.error("failed to store job: #{inspect(changeset)}")
        Logger.error(inspect(job))
    end

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:delete_job, job_name}, %{repo: repo} = state) do
    Logger.info("deleting job job #{inspect(job_name)}")

    case Jobs.delete_job_by_name(job_name, repo) do
      {:ok, _job} ->
        Logger.info("job #{inspect(job_name)} was removed successfully")

      {:error, reason} ->
        Logger.error("failed to remove job #{inspect(job_name)}: #{inspect(reason)}")
    end

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:purge, %{repo: repo} = state) do
    Jobs.delete_all(repo)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:update_job, job}, %{repo: repo} = state) do
    case Jobs.full_update(job, repo) do
      {:error, reason} ->
        Logger.error("failed to update job: #{inspect(reason)}")
        Logger.error(inspect(job))

      {:ok, _changeset} ->
        Logger.info("successfully updated job")
        Logger.debug(inspect(job))
    end

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:update_job_state, job, job_state}, %{repo: repo} = state) do
    Logger.info("updating job #{inspect(job)} to #{inspect(job_state)}")
    Jobs.update(job, %{state: job_state}, repo)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:update_last_execution_date, last_execution_date}, state) do
    {:noreply, state |> Map.put(:last_execution_time, last_execution_date)}
  end

  @impl GenServer
  def handle_call(:get_all_jobs, _from, %{repo: repo} = state) do
    Logger.debug("getting all jobs")
    {:reply, Jobs.get_all(repo), state}
  end

  @impl GenServer
  def handle_call(:last_execution_date, _from, %{last_execution_time: led} = state) do
    {:reply, led, state}
  end
end
