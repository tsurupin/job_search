defmodule Customer.Es do
  defmacro __using__(opts) do
    quote do

      alias Customer.Es

      @__using_resource__ unquote(opts)

      def estype, do: Es.Index.name_type(__MODULE__)
      def esindex(name \\ nil), do: name || Es.Index.name_index(__MODULE__)

    end
  end
end
