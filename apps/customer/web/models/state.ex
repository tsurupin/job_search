defmodule Customer.State do
  use Customer.Web, :model
    alias Customer.{Area}

  schema "states" do
    has_many :areas, Area, on_delete: :delete_all
    field :name
    field :abbreviation
    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct  \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, ~w(name))
    |> validate_required(~w(name))
  end
end
