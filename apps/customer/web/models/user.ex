defmodule Customer.User do
  use Customer.Web, :model

  schema "users" do
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
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def registration_changeset(model \\ %__MODULE__{}, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  def get_or_create_by!(auth) do
    IO.inspect auth
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
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil && &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

end
