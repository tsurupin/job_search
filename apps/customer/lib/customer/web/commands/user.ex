defmodule Customer.Web.Command.User do
  use Customer.Command, model: Customer.Web.User
  alias Customer.Web.User


  def get_or_insert_by(multi, %{info: auth_info}) do
    case Repo.get_by(User, email: auth_info.email) do
      nil -> insert_by(multi, auth_info)
      user -> Multi.run(multi, :user, fn _ -> {:ok, user} end)
    end
  end

  defp insert_by(multi, auth_info) do
    Multi.insert(multi, :user, User.registration_changeset(%User{}, auth_info))
  end

end