defmodule QuantumStorageEcto.Types.QuantumStrategy do
  alias Quantum.RunStrategy
  use Ecto.Type

  def type(), do: :map

  def cast(value) do
    {:ok, value}
  end

  def dump(%RunStrategy.All{} = value), do: do_dump(value)
  def dump(%RunStrategy.Random{} = value), do: do_dump(value)
  def dump(%RunStrategy.Local{} = value), do: do_dump(value)
  def dump(_), do: :error

  defp do_dump(value) do
    strategy_name = value.__struct__
    data = value |> Map.from_struct() |> Map.put(:strategy, strategy_name)
    {:ok, data}
  end

  def load(value) when is_map(value) do
    strategy_name = Map.fetch!(value, :strategy_name)
    module_name = Module.concat(Quantum.RunStrategy, strategy_name)
    params = value |> Map.drop([:strategy_name])
    {:ok, struct!(module_name, params)}
  end

  def load(_), do: :error
end
