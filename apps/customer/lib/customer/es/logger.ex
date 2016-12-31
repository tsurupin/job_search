
defmodule Customer.Es.Logger do
  require Logger

  def ppdebug(query) do
    json = JSX.encode!(query)
    Logger.debug JSX.prettify!(json)
    Logger.debug json
  end
end
