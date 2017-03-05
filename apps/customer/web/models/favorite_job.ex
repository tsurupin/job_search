defmodule Customer.FavoriteJob do
  use Customer.Web, :model

  schema "favorite_jobs" do
    field :interest, :integer, default: 3
    field :status, :integer, default: 0
    field :remarks, :string
    timestamps()

    belongs_to :user, User
    belongs_to :job, Job

  end

  @required_fields ~w(user_id job_id)a

  @doc """

  """

  def changeset(favorite_job \\ %__MODULE__{}, params \\ %{}) do
    cast(favorite_job, params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:interest, 1..5)
    |> validate_inclusion(:status, 1..5)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:job_id)
    |> unique_constraint(:job_id, name: :favorite_job_user_id_and_job_id_unique_index)
  end
end