use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :meli, Meli.Endpoint,
  secret_key_base: "this-is-very-important-secret"

# Configure your database
config :meli, Meli.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "meli_prod",
  pool_size: 20

config :meli, :smtp,
  relay: "smtp.server.com",
  port: 465,
  username: "john@server.com",
  password: "doedoedoe"
