defmodule Customer.Web.FavoriteJob do
  use Customer.Web, :model

  schema "favorite_jobs" do
    field :interest, :integer, default: 1
    field :remarks, :string
    field :status, :integer
    timestamps()

    belongs_to :user, User
    belongs_to :job, Job

  end

  @required_fields ~w(user_id job_id)a
  @optional_fields ~w(interest remarks status)a

  @doc """

  """

  def changeset(favorite_job \\ %__MODULE__{}, params \\ %{}) do
    cast(favorite_job, params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:interest, 1..5)
    |> validate_number(:status, less_than_or_equal_to: 5)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:job_id)
    |> unique_constraint(:job_id, name: :favorite_job_user_id_and_job_id_unique_index)
  end

  def build(%{user_id: user_id, job_id: job_id} = params) do
    changeset(%__MODULE__{}, params)
  end

  def update(favorite_job, params) do
    changeset(favorite_job, params)
  end

end