defmodule Customer.Es do
  defmacro __using__(opts) do
    quote do

      alias Customer.Es

      @__using_resource__ unquote(opts)

      def estype(model), do: Es.Index.name_type(model)
      def esindex(model, name \\ nil), do: name || Es.Index.name_index(model)

    end
  end
end
