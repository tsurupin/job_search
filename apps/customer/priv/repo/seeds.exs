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
Application.load(:tzdata)
:ok = Application.ensure_started(:tzdata)
alias Customer.Web.{TechKeyword, Area, State}
alias Customer.Repo

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

states = [
  %{name: "California", abbreviation: "CA", areas: ["San Francisco", "Mountai View", "San Jose", "South San Francisco"]},
  %{name: "New York", abbreviation: "NY", areas: ["Manhattan"]}
]

Enum.each(states, fn(temp_state) ->
  state =
    State.changeset(%State{}, %{name: temp_state.name, abbreviation: temp_state.abbreviation})
    |> Repo.insert!
  Enum.each(temp_state.areas, fn(area) ->
    Area.changeset(%Area{}, %{name: area, state_id: state.id})
    |> Repo.insert!
  end)
end)

Enum.each(tech_keywords, fn(keyword) ->
  Enum.each(keyword.names, fn(name) ->
    TechKeyword.changeset(%TechKeyword{}, %{type: keyword.type, name: name})
    |> Repo.insert!
  end)
end)

# Circular dependencies.
# Scraper.Sites.Accel.Show.perform("http://google/com", "Sample", "Software engineer", "San Francisco, CA, US", :test)
# Scraper.Sites.A16z.Show.perform("http://google/com", "Sample", "Software engineer", ["San Francisco, CA, US"], :test)
# Scraper.Sites.Sequoia.Show.perform("http://google/com", :test)
