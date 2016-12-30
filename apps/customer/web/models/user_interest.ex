defmodule Customer.UserInterest do
  use Customer.Web, :model

  schema "user_interests" do
    field :degree, :integer

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct  \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [:degree])
    |> validate_required([:degree])
  end
end
