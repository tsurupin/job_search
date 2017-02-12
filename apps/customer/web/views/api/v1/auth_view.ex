defmodule Customer.Api.V1.AuthView do
   use Customer.Web, :view


   def render("logout.json", %{message: _message} = params) do
     params
   end

   def render("logout.json", %{error: _error} = params) do
     params
   end

end
