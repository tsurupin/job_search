defmodule Customer.UserActivity do
  use Customer.Web, :model


  schema "user_activities" do

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct  \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
