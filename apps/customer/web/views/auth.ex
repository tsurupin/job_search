defmodule Customer.AuthView do
   use Customer.Web, :view

   def render("logout.json", %{message: _message} = params) do
     params
   end

   def render("logout.json", %{error: _error} = params) do
     params
   end
   
   def render("callback.json", %{message: _message, token: _token} = params) do
     params
   end

   def render("callback.json", %{error: _error} = params) do
     params
   end
end
