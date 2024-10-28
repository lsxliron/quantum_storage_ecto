defmodule QuantumStorageEcto.Types.Term do
  use Ecto.Type

  @moduledoc """
  Implements and Ecto type that allows to save any elixir term to a database
  > #### Warning {: .warning}
  >
  > Handle with care, there is no guard validation since every term can be converted to a binary


  Reference: https://hexdocs.pm/ecto/Ecto.Type.html
  """

  def type(), do: :binary

  def cast(value) do
    {:ok, :erlang.binary_to_term(value)}
  end

  def load(value) do
    {:ok, :erlang.binary_to_term(value)}
  end

  def dump(value) do
    {:ok, :erlang.term_to_binary(value)}
  end
end
