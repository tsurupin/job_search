defmodule Customer.Auth.User do
  alias Customer.Repo
  alias Customer.User

  alias Comeonin.Pbkdf2

  def check_password(%Ueberauth.Auth{provider: :identity} = auth) do
    case Repo.get_by(User, email: auth.info.email) do
      nil -> {:error, :not_found}
      user ->
        password = auth.credentials.other[:password]
        if Pbkdf2.checkpw(password, user.encrypted_password) do
          {:ok, user}
        else
          {:error, :not_found}
        end
    end
  rescue
    _e in MatchError ->
      {:error, :not_found}
    _e in ArgumentError ->
      {:error, :not_found}
  end

  def enabled_password?(password, encrypted_password) do
    Pbkdf2.checkpw(password, encrypted_password)
  rescue
    _e in MatchError ->
      false
    _e in ArgumentError ->
      false
  end

  def auths(nil), do: []
  def auths(user) do
    Ecto.Model.assoc(user, :authorizations)
      |> Repo.all
      |> Enum.map(&(&1.provider))
  end

end
