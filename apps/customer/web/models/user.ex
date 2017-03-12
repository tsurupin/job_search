defmodule Customer.User do
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

  def get_or_create_by!(auth) do
    case Repo.get_by(__MODULE__, email: auth.info.email) do
      nil ->
        case create_by!(auth) do
          {:ok, user} -> user
          {:error, error} -> error
        end
      user -> user
    end
  end

  def create_by!(auth) do
    name = name_from_auth(auth)
    user =
      registration_changeset(%__MODULE__{}, %{email: auth.info.email, name: name})
      |> Repo.insert!
    {:ok, user}
  end

  defp name_from_auth(auth) do

    if !Blank.blank?(auth.info.name) do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil && &1 != ""))

      if Enum.empty?(name) do
        if Blank.blank?(auth.info.nickname) do
          "no name"
        else
          auth.info.nickname
        end
      else
        Enum.join(name, " ")
      end
    end
  end

end
