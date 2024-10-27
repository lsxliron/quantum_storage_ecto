defmodule QuantumStorageEcto.Types.Atom do
  use Ecto.Type

  @moduledoc """
  Implements and Ecto type that allows to save atoms to a database

  Reference: https://hexdocs.pm/ecto/Ecto.Type.html
  """

  def type, do: :string

  def cast(value) when is_atom(value), do: {:ok, value}

  def cast(value) when is_binary(value) do
    if String.valid?(value) do
      {:ok, String.to_atom(value)}
    else
      :error
    end
  end

  def cast(_), do: :error

  def load(value) do
    {:ok, String.to_atom(value)}
  end

  def dump(value) when is_atom(value) do
    {:ok, Atom.to_string(value)}
  end

  def dump(_), do: :error
end
