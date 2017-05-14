defmodule Customer.Es.Schema.Job do
  alias Customer.Es

  def completion(index) do
    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      settings do
        analysis do
          tokenizer "ngram_tokenizer",
            type: "nGram",  min_gram: "2", max_gram: "3",token_chars: ["letter", "digit"]

          analyzer "default",
            type: "custom", tokenizer: "ngram_tokenizer"
          analyzer "ngram_analyzer",
            tokenizer: "ngram_tokenizer"
        end
      end

      Es.Logger.ppdebug(index)
    index end)

    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      mappings do
        indexes "job_id", type: "integer"
        indexes "area", type: "string", index: "not_analyzed"
        indexes "title", type: "string", index: "not_analyzed"
        indexes "job_title", type: "string", index: "not_analyzed"
        indexes "techs", type: "string", index: "not_analyzed"
        indexes "details", type: "string", analyzer: "ngram_analyzer"
        indexes "updated_at", type: "date", format: "yyyy-MM-dd"
      end

      Es.Logger.ppdebug(index)
    index end)

    end
end
