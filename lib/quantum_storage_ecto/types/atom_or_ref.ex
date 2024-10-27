defmodule QuantumStorageEcto.Types.AtomOrRef do
  use Ecto.Type
  alias QuantumStorageEcto.Types

  @moduledoc """
  Implements and Ecto type that allows to save a value if its an atom or reference
  Handle with care

  Reference: https://hexdocs.pm/ecto/Ecto.Type.html
  """

  def type(), do: :string

  def cast(value) when is_reference(value) do
    Types.Reference.cast(value)
  end

  def cast(value) when is_atom(value) do
    Types.Atom.cast(value)
  end

  def cast(_), do: :error

  def load(value) when is_binary(value) do
    if value |> String.starts_with?("#Ref") do
      Types.Reference.load(value)
    else
      Types.Atom.load(value)
    end
  end

  def load(_), do: :error

  def dump(value) when is_reference(value) do
    Types.Reference.dump(value)
  end

  def dump(value) when is_atom(value) do
    Types.Atom.dump(value)
  end

  def dump(_), do: :error
end
