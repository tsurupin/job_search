defmodule Customer.Authorization do
  @moduledoc false

  use Customer.Web, :model
  alias Customer.User

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

end
