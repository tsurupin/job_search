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
  "software engineer" => ["rails engineer", "applications developer", "software engineer co-op", "episode portal engineer", "software developer payment", "rotational software engineer", "business technology developer", "product integration engineer", "api engineer", "content developer", "software engineer-", "temporary python developer", "temporary python engineer", "sdk", "open source engineer", "software development engineer", "production engineer", "windows engineer", "windows developer", "web engineer", "tools engineer", ".net developer", "core software engineer", "java engineer", "optimizations engineer", "embedded linux software engineer", "instagram", "sdk engineer", "computational geometry software engineer", "mid-level java software engineer", "staff identity engineer", "application engineer", "knowledge engineer", "senior salesforce developer", "ruby developer", "closure engineer", "creative developer", "ruby on rails developer", "ruby on rails engineer", "post sound engineer", "technical solutions engineer", "enginering", "web software engineer", "bitcoin protocol engineer", "platform engineer", "application platform engineer", "c++ engineer", "unity generalist engineer", "blockchain engineer", "research software engineer", "computational biology engineer", "game engineer", "karnel software engineer", "camera software engineer", "automation engineer", "internationalization engineer", "research engineer"],
  "senior software engineer" => ["sr. software engineer", "senior engineer", "senior algorithm", "sr software engineer", "senior platform engineer", "senior java software engineer", "sr embedded software engineer", "senior software development engineer", "senior visual effects software engineer", "senior software developer", "senior", "senior algorithm engineer", "sf", "senior data visualization engineer", "senior software engineer-finance engineering", "advanced software development engineer", "advanced software engineer", "senior javascript engineer", "senior performance and scale engineer", "senior platform architect", "senior node.js engineer", "senior web developer", "sr web developer backend", "senior camera software engineer", "senior virtual effects software engineer", "senior nanodegree service lead"],
  "full stack engineer" =>["full-stack software engineer", "software engineer full stack", "full-stack frontend engineer", "senior full stack web developer", "senior full stack developer", "senior full stack engineer", "full stack software engineer", "engineering generalist", "are you a full stack developer...?", "software engineering generalist", "full stack developer", "full-stack engineer", "growth engineer", "full stack web engineer", "generalist engineers", "full stack web instructor and curriculum engineer"],
  "frontend engineer" => [ "web ui engineer", "ui engineer", "front-end engineer", "senior frontend engineer", "senior front end engineer", "senioer ui engineer", "sr. ui engineer", "senior ui", "front end engineer", "front-end js", "rf design engineer", "ui architect", "javascript developer"],
  "principal engineer" => ["principal software development engineer", "chief architect", "pincipal software architect", "software architect container core platform", "principal software engineer", "software architect", "staff engineer", "staff software engineer", "architect"],
  "director of engineering" => ["senior manager", "engineering director", "director", "director of software engineering"],
  "lead software engineer" => ["technical lead", "software developer team lead", "software engineering lead", "lead performance engineer", "web developer lead", "lead software development engineer", "lead software developer", "lead", "team leader", "tech lead", "backend engineering lead", "lead mobile engineer", "sustaining team lead", "staff backend engineer", "staff software development engineer"],
  "software engineering manager" => ["development manager", "web engineering manager", "senior software engineer manager", "senior engineering manager", "engineering manager", "infrastructure and security manager", "software frameworks manager", "lead unity engineer", "brokerage engineering manager", "manager", "manager of data science"],
  "site reliability engineer" => ["devops", "senior cloud engineer", "software engineer cloud", "confluent cloud engineer", "software engineer cloud computing", "insfrastructure engineer", "senior devops engineer", "techops engineer", "systems engineer", "senior site reliability engineer", "network reliability engineer", "senioer devops", "senior infrastructure software engineer", "senior cloud integration engineer", "jira integration engineer", "senior cloud platform software engineer", "cloud software engineer", "private cloud technical engineer", "software integration engineer", "cloud platform engineer"],
  "backend engineer" => ["backend web developer", "backend-services engineer", "software engineer backend", "backend python engineer", "senior backend engineer", "senior backend software engineer", "senior back end developer", "backend software engineer","senior network engineer", "senior python backend engineer", "backend", "server applications software engineer", "java backend engineer", "server-side software engineer", "back-end engineer", "java server developer", "senior java server engineer"],
  "mobile engineer" => ["principal ios engineer", "android app engineer", "mobile application engineer", "android lead", "principal android engineer", "lead ios engineer", "senior android engineer", "senior android software engineer", "android engineer", "ios engineer", "senior ios developer", "ios developer", "senior ios engineer", "senior mobile engineer", "mobile developer", "senior android developer", "senior mobile developer", "junior android engineer", "android developer", "mobile software developer", "android software frameworks engineer", "android software engineer", "ios media", "ios media engineer", "ios software engineer", "senior ios software engineer", "mobile build engineer", "senior android development engineer", "iod instructor and curriculum engineer", "react native"],
  "qa engineer" => ["sr. software qa engineer", "software quality assurance engineer", "system test engineer", "software development engineer in test", "quality engineer", "release engineer", "build and release engineer", "release manager", "build"],
  "product manager" => ["senior product manager", "principal product manager", "product operations manager", "sr. product manager", "project manager"],
  "analyst" => ["energy analyst", "product operations analyst", "business analyst", "product analyst","principal actuarial analyst", "senior data analyst", "data analyst", "senior analyst", "senior platform researcher"],
  "data scientist" => ["statistics data scientist", "senioer data scientist", "machine learning data scientist", "professional services analyst", "data science lead", "marketing data scientist", "network data scientist", "senior data science engineer", "applied research scientist", "operations research scientist"],
  "data engineer" => ["big data architect", "big data operations engineer", "senior data engineer", "lead etl developer", "hadoop spark engineer", "data and analytics software engineer", "senior hadoop engineer", "hadoop engineer"],
  "machine learning engineer" => ["machine learning engineer", "machine", "senior machine learning engineer", "senior spark engineer", "computer vision engineer", "senior computer vision scientist", "computer vision research engineer"],
  "vp of engineering" => ["vp", "head of data science"],
  "security engineer" => ["principal security engineer", "software security engineer", "security software engineer", "lead security engineer"],
  "technical writer" => ["technical wditor", "senior technical writer", "developer advocate"]
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
    |> Repo.insert!
  end)
end
)

