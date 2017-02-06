defmodule Customer.Api.V1.AuthView do
   use Customer.Web, :view

   def render("request.json", %{callback_url: callback_url} = params) do
     %{}
   end

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
