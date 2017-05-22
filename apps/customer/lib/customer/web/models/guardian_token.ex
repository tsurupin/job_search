defmodule Customer.Web.GuardianToken do
  use Customer.Web, :model

  alias Customer.Repo
  alias Customer.Auth.GuardianSerializer

  @primary_key {:jti, :string, []}
  @derive {Phoenix.Param, key: :jti}
  schema "guardian_tokens" do
    field :aud, :string
    field :iss, :string
    field :sub, :string
    field :exp, :integer
    field :jwt, :string
    field :claims, :map

    timestamps
  end

end
