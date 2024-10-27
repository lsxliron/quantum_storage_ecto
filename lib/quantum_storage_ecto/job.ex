defmodule QuantumStorageEcto.Job do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuantumStorageEcto.Types.{Atom, AtomOrRef, Term}

  @moduledoc """
  Ecto compatible type for a `Quantum.Job`
  """

  @fields [
    :name,
    :overlap,
    :run_strategy,
    :schedule,
    :state,
    :task,
    :timezone
  ]
  @required_fields [
    :name,
    :run_strategy,
    :schedule,
    :task
  ]

  @typedoc """
  An Ecto representation of a `Quantum.Job`
  """
  @type t :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          name: atom() | reference(),
          overlap: boolean(),
          run_strategy: binary(),
          schedule: Crontab.CronExpression.t(),
          state: Quantum.Job.state(),
          task: binary(),
          timezone: atom(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key false
  schema "quantum_jobs" do
    field :name, AtomOrRef, primary_key: true
    field :overlap, :boolean, default: true
    field :run_strategy, Term
    field :schedule, Crontab.CronExpression.Ecto.Type
    field :state, Ecto.Enum, values: [:active, :inactive], default: :active
    field :task, Term
    field :timezone, Atom, default: :utc

    timestamps()
  end

  @spec changeset(job :: t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(job, attrs \\ %{}) do
    encoded_attrs =
      attrs
      |> update_in([:task], &:erlang.term_to_binary/1)
      |> update_in([:run_strategy], &:erlang.term_to_binary/1)

    job
    |> cast(encoded_attrs, @fields)
    |> validate_required(@fields)
    |> validate_required(@required_fields)
  end
end
