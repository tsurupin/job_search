# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :customer,
  ecto_repos: [Customer.Repo]

# Configures the endpoint
config :customer, Customer.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "o9lvpFUXHXMtN6kFpZuHDVqEIYSqyYPK1nQoxQZ5g6QKyFHVZbp3BVPEqHDBIo1U",
  render_errors: [view: Customer.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Customer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "profile"]}
  ]

config :guardian, Guardian,
issuer: "Customer.#{Mix.env}",
ttl: {60, :days },
verify_issuer: true,
serializer: Customer.Auth.GuardianSerializer,
secret_key: to_string(Mix.env),
hooks: GuardianDb,
permissions: %{
  default: [
    :read_profile,
    :write_profile,
    :read_token,
    :revoke_token
  ],
}

config :guardian_db, GuardianDb,
repo: Customer.Repo,
sweep_interval: 60

config :arc,
  storage: Arc.Storage.S3,
  bucket: {:system, "AWS_S3_BUCKET"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
