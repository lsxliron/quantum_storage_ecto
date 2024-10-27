defmodule QuantumStorageEcto.Repo do
  use Ecto.Repo,
    otp_app: :quantum_storage_ecto,
    adapter: Ecto.Adapters.Postgres
end
