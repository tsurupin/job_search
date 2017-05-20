use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :customer, Customer.Web.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
config :wallaby, :max_wait_time, 250
config :phoenix, :stacktrace_depth, 35

config :honeybadger, :environment_name, :test
config :customer, :environment, :test
# Configure your database
config :customer, Customer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "tomoakitsuruta",
  password: "",
  database: "customer_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
