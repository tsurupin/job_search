defmodule Customer.Authorization do
  @moduledoc false

  use Customer.Web, :model
  alias Customer.User
  alias Customer.Repo

  schema "authorizations" do
    belongs_to :user, User
    field :provider, :string
    field :uid, :string
    field :token, :string
    field :refresh_token, :integer
    field :expired_at, :integer

    timestamps
  end

  @required_fields ~w(provider uid user_id token)a
  @optional_fields ~w(refresh_token expired_at)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:provider_uid)
  end

  def current_auth(user_id) do
     Repo.one(last(from a in __MODULE__, where: a.user_id == ^user_id))
  end

  def expired?(authorization) do
     authorization.expired_at && authorization.expired_at < Guardian.Utils.timestamp
  end

  def get_user_by(authorization, current_user) do
    case Repo.one(Ecto.assoc(authorization, :user)) do
      nil -> {:error, :user_not_found}
      user ->
        if current_user && current_user.id != user.id do
          {:error, :user_does_not_match}
        else
          {:ok, user}
        end
    end
  end

  def reset_authorization!(authorization, user, auth) do
    Repo.transaction(fn ->
      Repo.delete!(authorization)
      create_by!(user, auth)
    end)
  end

  def create_by!(user, auth) do
    build_assoc(user, :authorizations)
    |> changeset(build_attributes(auth))
    |> Repo.insert!
  end

  defp build_attributes(auth) do
    %{
      provider: to_string(auth.provider),
      uid: auth.uid,
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      expired_at: auth.credentials.expires_at
    }
  end

end
