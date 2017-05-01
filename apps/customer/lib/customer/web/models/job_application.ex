defmodule Customer.Web.JobApplication do
  use Customer.Web, :model

  schema "job_applications" do
    field :status, :integer, default: 1, null: false
    field :comment, :string
    timestamps()

    belongs_to :user, User
    belongs_to :job, Job
  end

  @required_fields ~w(status user_id job_id)a
  @optional_fields ~w(comment)a

  def changeset(job_application \\ %__MODULE__{}, params) do
    cast(job_application, params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:status, 0..5)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:job_id)
    |> unique_constraint(:job_id, name: :job_applications_application_unique_index)
  end

  def build(params) do
    changeset(%__MODULE__{}, params)
  end

  def update(job_application, params) do
    changeset(job_application, params)
  end

end