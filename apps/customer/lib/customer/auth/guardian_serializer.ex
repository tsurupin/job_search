defmodule Customer.Auth.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Customer.Repo
  alias Customer.Web.User

  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(error), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: { :ok, Repo.get(User, id) }
  def from_token(error), do: { :error, "Unknown resource type" }

end
