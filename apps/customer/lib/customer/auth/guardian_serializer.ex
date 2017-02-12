defmodule Customer.Auth.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Customer.Repo
  alias Customer.User

  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(error) do
    IO.inspect error
    {:error, "Unknown resource type"}
  end

  def from_token("User:" <> id), do: { :ok, Repo.get(User, id) }
  def from_token(error) do
    IO.inspect "from_tokne-------"
    IO.inspect error
    { :error, "Unknown resource type" }
  end

end
