defmodule Scraper.Site.Helper.TechKeywordsFinder do
  @infra ~w(Docker Ansible Chef AWS Amazonwebservice Pupet)
  @datastore ~w(MySQL PostgreSQL Redis Memcache MongoDB Cassandra Elasticsearch elastic-search spark hadoop)
  @frontend ~w(HTML CSS ES6 ES7 Javascript React Angular Ember Elm Redux)
  @backend ~w(Ruby Rails ROR Ruby-on-Rails Node Elixir Phoenix Ember PHP Django Python Scala Java C# C++ Go SQL)
  @mobile ~w(Swift Objective-c Android)

  def perform(text) do
    find_keywords(text, @infra ++ @datastore ++ @frontend ++ @backend ++ @mobile, [])
  end

  defp find_keywords(text, [], matching_keywords), do: matching_keywords
  defp find_keywords(text, [keyword | tail], matching_keywords) do
    case Regex.match?(~r/#{keyword}/i, text) do
      true -> find_keywords(text, tail, matching_keywords ++ [keyword])
      false -> find_keywords(text, tail, matching_keywords)
    end
  end
end
