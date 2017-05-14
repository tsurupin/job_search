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

alias Customer.Web.{TechKeyword, State, JobTitle, JobTitleAlias}
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

job_title_and_aliases = %{
  "software engineer" => ["rails engineer", "software development engineer", "production engineer", "windows engineer", ".net developer", "core software engineer"],
  "senior software engineer" => ["sr. software engineer", "senior java software engineer", "sr embedded software engineer", "senior software development engineer"],
  "full stack engineer" =>["full stack software engineer", "full stack developer", "full-stack engineer", "growth engineer"],
  "frontend engineer" => ["full-stack software engineer", "web ui engineer", "senior frontend engineer", "senior front end engineer", "senioer ui engineer", "sr. ui engineer", "front-end js", "rf design engineer"],
  "principal engineer" => ["principal software development engineer"],
  "director of engineering" => ["senior manager"],
  "lead software engineer" => ["software engineering lead", "lead performance engineer"],
  "software engineering manager" => ["development manager", "engineering manager", "infrastructure and security manager", "development manager"],
  "site reliability engineer" => ["devops", "insfrastructure engineer", "senior devops engineer", "techops engineer", "systems engineer", "senior site reliability engineer", "network reliability engineer", "senioer devops", "senior infrastructure software engineer", "senior cloud integration engineer"],
  "backend engineer" => ["backend web developer", "senior backend engineer", "backend software engineer", "senior network engineer"],
  "mobile engineer" => ["senior ios developer", "lead ios engineer", "senior android engineer", "android engineer", "ios engineer", "senior ios developer", "senior mobile engineer"],
  "qa engineer" => ["sr. software qa engineer", "software quality assurance engineer", "system test engineer", "software development engineer in test", "sr. software qa engineer", "quality engineer", "release engineer", "build and release engineer"],
  "product manager" => ["senior product manager", "principal product manager", "product operations manager", "sr. product manager", "project manager"],
  "analyst" => ["energy analyst", "product operations analyst", "business analyst", "product analyst"],
  "data scientist" => ["statistics data scientist", "senioer data scientist", "professional services analyst", "data science lead"],
  "data engineer" => ["big data architect", "big data operations engineer"],
  "security engineer" => ["principal security engineer", "security software engineer", "lead security engineer"]
}

Enum.each(Map.keys(job_title_and_aliases), fn(title) ->
  JobTitle.changeset(%JobTitle{}, %{name: title})
  |> Repo.insert!
end
)

Enum.each(job_title_and_aliases, fn{title, aliases} ->
  job_title = Repo.get_by(JobTitle, name: title)
  Enum.each(aliases, fn(alias) ->
    JobTitleAlias.changeset(%JobTitleAlias{}, %{job_title_id: job_title.id, name: alias})
  end)
end
)

