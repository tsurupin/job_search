defmodule Customer.Es.Schema.TechKeyword do
  alias Customer.Es

  def completion(index) do
    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      settings do
        analysis do
          analyzer "autocomplete_analyzer",
          [
            filter: ["lowercase", "asciifolding", "edge_ngram"],
            tokenizer: "whitespace"
          ]
          filter "edge_ngram", [type: "edgeNGram", min_gram: 1, max_gram: 15]
        end
      end

      Es.Logger.ppdebug(index)
    index end)

    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      mappings do
        indexes "name", type: "string", analyzer: "autocomplete_analyzer"
      end

      Es.Logger.ppdebug(index)
    index end)

  end
end
