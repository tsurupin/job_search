defmodule Customer.Web.User do
  use Customer.Web, :model
  alias Customer.Blank

  schema "users" do
    field :name, :string, null: false
    field :email, :string
    field :is_admin, :boolean, default: false

    has_many :authorizations, Authorization
    has_many :favorite_jobs, FavoriteJob
    has_many :job_applications, JobApplication
    timestamps()
  end

  @required_fields ~w(name email)a
  @optional_fields ~w(is_admin)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model \\ %__MODULE__{}, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
  end

  def registration_changeset(model \\ %__MODULE__{}, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
  end


end
