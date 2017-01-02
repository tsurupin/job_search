defmodule Customer.Es.Sort do
   import Tirexs.Search

   def perform(%{updated_at: sort}) do
     Tirexs.Search.sort do
       [updated_at: [order: sort]]
    end
    |> Keyword.get(:sort)
  end
end
