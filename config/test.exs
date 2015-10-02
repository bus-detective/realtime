use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bd_rt, BdRt.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bd_rt, BdRt.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bus_detective_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# You need to set your username and password in a local config
# This is compile time, so dotenv won't work. Basically I don't
# know how to make this optional or have reasonable defaults
import_config "local.exs"
