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

alias Customer.Web.{TechKeyword, State}
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

states = ["Alabama,AL", "Alaska,AK", "Arizona,AZ", "Arkansas,AR", "California,CA",
          "Colorado,CO", "Connecticut,CT", "Delaware,DE", "Florida,FL", "Georgia,GA",
          "Hawaii,HI", "Idaho,ID", "Illinois,IL", "Indiana,IN", "Iowa,IA", "Kansas,KS",
          "Kentucky,KY", "Louisiana,LA", "Maine,ME", "Maryland,MD", "Massachusetts,MA",
          "Michigan,MI", "Minnesota,MN", "Mississippi,MS", "Missouri,MO", "Montana,MT",
          "Nebraska,NE", "Nevada,NV", "New Hampshire,NH", "New Jersey,NJ",
          "New Mexico,NM", "New York,NY", "North Carolina,NC", "North Dakota,ND",
          "Ohio,OH", "Oklahoma,OK", "Oregon,OR", "Pennsylvania,PA", "Rhode,Island,RI",
          "South Carolina,SC", "South Dakota,SD", "Tennessee,TN", "Texas,TX", "Utah,UT",
          "Vermont,VT", "Virginia,VA", "Washington,WA", "West Virginia,WV",
          "Wisconsin,WI", "Wyoming,WY"
          ]
states_with_abbreviations = Enum.map(states, &(String.split(&1, ",")))

Enum.each(states_with_abbreviations, fn(state) ->
  State.changeset(%State{}, %{name: Enum.at(state, 0), abbreviation: Enum.at(state, 1)})
  |> Repo.insert!
end)


Enum.each(tech_keywords, fn(keyword) ->
  Enum.each(keyword.names, fn(name) ->
    TechKeyword.changeset(%TechKeyword{}, %{type: keyword.type, name: name})
    |> Repo.insert!
  end)
end)

# Circular dependencies.
# Scraper.Site.Accel.Show.perform("http://google/com", "Sample", "Software engineer", "San Francisco, CA, US", :test)
# Scraper.Site.A16z.Show.perform("http://google/com", "Sample", "Software engineer", ["San Francisco, CA, US"], :test)
# Scraper.Site.Sequoia.Show.perform("http://google/com", :test)
