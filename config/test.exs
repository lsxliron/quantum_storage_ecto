import Config

# config :quantum_storage_ecto, QuantumStorageEcto.Repo, priv: "lib/quantum_storage_ecto"

config :quantum_storage_ecto,
  ecto_repos: [QuantumStorageEcto.Repo],
  generators: [timestamp_type: :utc_datetime]

config :quantum_storage_ecto, QuantumStorageEcto.Repo,
  database: "quantum_storage_ecto_test",
  username: "quantum_storage_ecto_test",
  password: "quantum_storage_ecto_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2
