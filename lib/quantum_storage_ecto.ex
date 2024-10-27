defmodule QuantumStorageEcto do
  @moduledoc """
  A storage adapter for `Quantum` based on Ecto

  ## How to Use?

  Simply add `QuantumStorageEcto` in `Quantum` config and run the required migrations.

  The `Repo` (`Ecto.Repo`) parameter is required and is used to communicate with the database

  ```elixir
  config :my_app, MyApp.Scheduler,
    storage: QuantumStorageEcto,
    storage_opts: [
      repo: MyApp.Repo,
    ]
  ```

  ## Running the migrations
  1. Create a new migration file in your application
     ```sh
     mix ecto.gen.migration adding_quantum_storage_ecto
     ```

  2. Edit the newly created migration file
     ```elixir
    use Ecto.Migration

    def up do
      QuantumStorageEcto.Migrations.V1AddJobsTable.up()
    end

    def down do
      QuantumStorageEcto.Migrations.V1AddJobsTable.down()
    end
    ```
  3. migrate
     ```sh
     mix ecto.migrate
     ```



  ## Database Tables
  The adapter creates 2 database tables:
  - `quantum_jobs` - this table stores the job definitions
  - `quantum_last_execution_date` - holds the last execution data
  """
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
