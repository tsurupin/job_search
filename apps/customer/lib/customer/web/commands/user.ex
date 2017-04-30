defmodule Customer.Web.Command.User do
  use Customer.Command, model: Customer.Web.User
  alias Customer.Web.User
  alias Customer.Blank

  def get_or_insert_by(multi, auth) do
    case Repo.get_by(User, email: auth.info.email) do
      nil -> insert_by(multi, auth)
      user -> Multi.run(multi, :user, fn _ -> {:ok, user} end)
    end
  end


  defp insert_by(multi, auth) do
    Multi.insert(multi, :user, User.registration_changeset(%User{}, build_attributes(auth.info)))
  end

  defp build_attributes(%{name: name, first_name: first_name, last_name: last_name, nickname: nickname, email: email} = _auth) do
    %{
      name: name_from_auth(first_name, last_name, nickname, name),
      email: email
    }
  end

  defp name_from_auth(first_name, last_name, nickname, name) do
    if Blank.blank?(name) do
      name_from_auth([first_name, last_name], nickname)
    else
      name
    end
  end

  defp name_from_auth(names, nickname) do
    name = names |> Enum.filter(&(&1 != nil && &1 != ""))
    if Enum.empty?(name) do
      name_from_auth(nickname)
    else
      Enum.join(name, " ")
    end
  end

  defp name_from_auth(nickname) do
    if Blank.blank?(nickname) do
      "no name"
    else
      nickname
    end
  end

end