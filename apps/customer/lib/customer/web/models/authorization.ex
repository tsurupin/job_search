defmodule Customer.Web.Authorization do
  @moduledoc false

  use Customer.Web, :model

  schema "authorizations" do
    field :provider, :string, null: false
    field :uid, :string
    field :token, :string, null: false
    field :refresh_token, :string
    field :expired_at, :integer

    timestamps

    belongs_to :user, User
  end

  @required_fields ~w(provider uid user_id token)a
  @optional_fields ~w(refresh_token expired_at)a

  def changeset(authorization, params \\ %{}) do
    cast(authorization, params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:provider_uid)
  end

  def expired?(%__MODULE__{expired_at: expired_at}) when is_nil(expired_at), do: true

  def expired?(%__MODULE__{expired_at: expired_at}) do
     expired_at < Guardian.Utils.timestamp
  end

  def build_from_user_with_auth(user, auth) do
    build_assoc(user, :authorizations)
    |> changeset(build_attributes(auth))
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

  def update(authorization, %{refresh_token: refresh_token, expired_at: expired_at} = params) do
    changeset(authorization, params)
  end

end
