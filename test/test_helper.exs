opts = [strategy: :one_for_one, name: QuantumStorageEcto.Supervisor]

Supervisor.start_link([QuantumStorageEcto.Repo], opts)
ExUnit.start()
