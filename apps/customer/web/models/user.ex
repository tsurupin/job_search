defmodule Customer.User do
  use Customer.Web, :model
  alias Customer.{UserInterest}

  schema "users" do
    has_many :user_interessts, UserInterest
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :passowrd_hash, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct  \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :passowrd_hash])
    |> validate_required([:first_name, :last_name, :email, :passowrd_hash])
  end
end
