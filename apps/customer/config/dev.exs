use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :customer, Customer.Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/webpack/bin/webpack.js",  "--watch", "--color",
                     cd: Path.expand("../assets", __DIR__)]]


# Watch static and templates for browser reloading.
config :customer, Customer.Web.Endpoint,
  live_reload: [
    patterns: [
      #~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/customer/web/views/.*(ex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :exsentry,
  otp_app: :customer,
  dsn: ""
# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :customer, Customer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "tomoakitsuruta",
  password: "",
  database: "customer_dev",
  hostname: "localhost",
  pool_size: 10

config :honeybadger, environment_name: :dev

config :tirexs, :uri, "http://127.0.0.1:9200"
