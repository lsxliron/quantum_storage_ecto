defmodule QuantumStorageEcto.Jobs do
  alias QuantumStorageEcto.Job
  @dialyzer [{:nowarn_function, insert: 2}]

  @moduledoc """
  Functions to interact with the job model
  """

  @doc """
  Inserts a job to the database.

  ## Parameters
  - `job_attrs` - the new job attributes
  - `repo` - the repo module that should be use to communicate with the database
  """
  @spec insert(job_attrs :: map(), repo :: module()) ::
          {:ok, Job.t()} | {:error, Ecto.Changeset.t()}
  def insert(job_attrs, repo) do
    %Job{} |> Job.changeset(job_attrs) |> repo.insert()
  end

  @doc """
  Deletes a job from the database by its name.

  ## Parameters
  - `job_name` - the job name to delete
  - `repo` - the repo module that should be use to communicate with the database
  """
  @spec delete_job_by_name(job_name :: Quantum.Job.name(), repo :: module()) ::
          {:ok, Job.t()} | {:error, Ecto.Changeset.t()}
  def delete_job_by_name(job_name, repo) do
    repo.get_by(Job, name: job_name) |> delete(repo)
  end

  @doc """
  Deletes a job from the database

  ## Parameters
  - `job` - the job object to delete
  - `repo` - the repo module that should be use to communicate with the database
  """
  @spec delete(job :: Job.t() | nil, repo :: module()) ::
          {:ok, Job.t()} | {:error, Ecto.Changeset.t()} | {:error, String.t()}
  def delete(nil, _repo) do
    {:error, "job does not exists"}
  end

  def delete(job, repo), do: repo.delete(job)

  @doc """
  Perform a full update for the job object. This function requires all the
  job attributes to be updated

  ## Parameters
  - `job` - the job to update
  - `repo` - the repo module that should be use to communicate with the database
  """

  @spec full_update(job :: Job.t(), repo :: module()) ::
          {:ok, Job.t()} | {:error, Ecto.Changeset.t() | String.t()}
  def full_update(job, repo) do
    case repo.get(Job, job.name) do
      nil ->
        {:error, "job #{inspect(job.name)} does not exists"}

      job_to_update ->
        attrs = job |> Map.from_struct()

        job_to_update
        |> Job.changeset(attrs)
        |> repo.update()
    end
  end

  @doc """
  Returns all jobs from the database

  ## Parameters
  - `repo` - the repo module that should be use to communicate with the database
  """
  @spec get_all(repo :: module()) :: list(Job.t())
  def get_all(repo) do
    Job |> repo.all() |> Enum.map(&decode_job/1)
  end

  defp decode_job(job) do
    params =
      job
      |> Map.from_struct()
      |> Map.drop([:__meta__, :inserted_at, :updated_at])

    struct!(Quantum.Job, params)
  end

  @doc """
  Purges all jobs from the database

  ## Parameters
  - `repo` - the repo module that should be use to communicate with the database
  """
  @spec delete_all(repo :: module()) :: {non_neg_integer(), nil | [term()]}
  def delete_all(repo) do
    Job |> repo.delete_all()
  end

  @doc """
  Updates a job with the provided attribute

  ## Parameters
  - `job_name` - the job name to update. Jobs without atom names are using a `reference` instead
  - `attrs` - a map with the attributes to update
  - `repo` - the repo module that should be use to communicate with the database
  """
  @spec update(job_name :: atom() | reference(), attrs :: map(), repo :: module()) ::
          {:ok, Job.t()} | {:error, Ecto.Changeset.t()}
  def update(job, attrs, repo) do
    repo.get(Job, job) |> Job.update_changeset(attrs) |> repo.update
  end
end
