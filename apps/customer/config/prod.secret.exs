use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :customer, Customer.Endpoint,
  secret_key_base: "PDN6QiBmQGJR5RqUPKvAxMDrq3c5MU4VVis6VSGcbKu5HghGOqB+A/r7X6f9kNjE"

# Configure your database
config :customer, Customer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "customer_prod",
  pool_size: 20
