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
    |> cast(params_with_name(params), @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
  end

  defp params_with_name(%{name: name, first_name: first_name, last_name: last_name, nickname: nickname, email: email} = _params) do
    %{
      name: name_from_auth(first_name, last_name, nickname, name),
      email: email
    }
  end

  defp name_from_auth(first_name, last_name, nickname, name) do
    if Blank.blank?(name) do
      name_from_auth([first_name, last_name], nickname)
    else
      name
    end
  end

  defp name_from_auth(names, nickname) do
    name = names |> Enum.filter(&(&1 != nil && &1 != ""))
    if Enum.empty?(name) do
      name_from_auth(nickname)
    else
      Enum.join(name, " ")
    end
  end

  defp name_from_auth(nickname) do
    if Blank.blank?(nickname) do
      "no name"
    else
      nickname
    end
  end

end
