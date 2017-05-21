# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"8bF*qnKfyG,tY=lAaJ=IV)vJH_d/.ZnriVyU??1SnXq]Pi{uK8PRX6q(w4i{2Aj&"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set output_dir: "apps/job_search/rel/job_search"
  set cookie: :"<s9GW7$m9X4TN.ajYCugR^W.XSLA[@9*6!uQ.j7NVrHFnpGL4RnNEb<S;<9t^$42"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :job_search do
  set version: "0.1.4"
  set applications: [
    :runtime_tools,
    customer: :permanent,
    scraper: :permanent
  ]
end
