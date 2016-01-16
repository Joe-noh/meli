ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Meli.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Meli.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Meli.Repo)

