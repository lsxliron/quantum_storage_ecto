defmodule QuantumStorageEcto do
  # alias QuantumStorageEcto.Server
  @behaviour Quantum.Storage

  @impl Quantum.Storage
  def child_spec(init_arg) do
    %{id: __MODULE__, start: {__MODULE__.Server, :start_link, [init_arg]}}
  end

  @impl Quantum.Storage
  def jobs(storage_pid) do
    GenServer.call(storage_pid, :get_all_jobs)
  end

  @impl Quantum.Storage
  def last_execution_date(storage_pid) do
    GenServer.call(storage_pid, :last_execution_date)
  end

  @impl Quantum.Storage
  def purge(storage_pid) do
    GenServer.cast(storage_pid, :purge)
  end

  @impl Quantum.Storage
  def add_job(storage_pid, job) do
    GenServer.cast(storage_pid, {:add_job, job})
  end

  @impl Quantum.Storage
  def delete_job(storage_pid, job) do
    GenServer.cast(storage_pid, {:delete_job, job})
  end

  @impl Quantum.Storage
  def update_job(storage_pid, job) do
    GenServer.cast(storage_pid, {:update_job, job})
  end

  @impl Quantum.Storage
  def update_job_state(storage_pid, job, state) do
    GenServer.cast(storage_pid, {:update_job_state, job, state})
  end

  @impl Quantum.Storage
  def update_last_execution_date(storage_pid, last_execution_date) do
    GenServer.cast(storage_pid, {:update_last_execution_date, last_execution_date})
  end
end
