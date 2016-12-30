# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Customer.Repo.insert!(%Customer.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Customer.{TechKeyword, Repo}
infra = ~w(Docker Ansible Chef AWS Amazonwebservice Pupet)
datastore = ~w(MySQL PostgreSQL Redis Memcache MongoDB Cassandra Elasticsearch elastic-search spark hadoop)
frontend = ~w(HTML CSS ES6 ES7 Javascript React Angular Backbone Ember Elm Redux)
backend = ~w(Ruby Rails ROR Ruby-on-Rails Node Elixir Phoenix PHP Django Python Scala Java C# C++ Go SQL)
mobile = ~w(Swift Objective-c Android)

tech_keywords = [
  %{type: "infra", names: infra},
  %{type: "datastore", names: datastore},
  %{type: "frontend", names: frontend},
  %{type: "backend", names: backend},
  %{type: "mobile", names: mobile}
]

Enum.each(tech_keywords, fn(keyword) ->
  Enum.each(keyword.names, fn(name) ->
    TechKeyword.changeset(%TechKeyword{}, %{type: keyword.type, name: name})
    |> Repo.insert!
  end)
end)
