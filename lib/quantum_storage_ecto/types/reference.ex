defmodule QuantumStorageEcto.Types.Reference do
  use Ecto.Type

  @moduledoc """
  Implements and Ecto type that allows to save references to a database

  Reference: https://hexdocs.pm/ecto/Ecto.Type.html
  """
  def type, do: :string

  def cast(value) when is_reference(value), do: {:ok, value}

  def cast(value) when is_binary(value) do
    {:ok,
     value
     |> String.replace("#Reference<", "#Ref<")
     |> String.to_charlist()
     |> :erlang.list_to_ref()}
  end

  def cast(_), do: :error

  def dump(value) when is_reference(value) do
    {:ok, value |> inspect() |> String.replace("#Reference", "#Ref")}
  end

  def dump(_), do: :error

  def load(value) when is_binary(value) do
    {:ok, value |> String.to_charlist() |> :erlang.list_to_ref()}
  end

  def load(_), do: :error
end
