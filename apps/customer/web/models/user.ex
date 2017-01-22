defmodule Customer.User do
  use Customer.Web, :model
  alias Customer.{UserInterest, Authorization}

  schema "users" do
    has_many :user_interessts, UserInterest
    has_many :authorizations,  Authorization
    field :name, :string
    field :email, :string
    field :is_admin, :boolean



    timestamps
  end

  @required_fields ~w(email name)a
  @optional_fields ~w(is_admin)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model \\ %__MODULE__{}, params \\ %{}) do
    model
    |> cast(params, @reuiqred_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  # def find_and_confirm_password(%{"email" => email, "password" => password }) do
  #   if Repo.find_by(__MODULE__, email: email, password: password) do
  #   else
  #
  #   end
  # end

end
