defmodule Customer.State do
  use Customer.Web, :model
    alias Customer.{Area}

  schema "states" do
    has_many :areas, Area, on_delete: :delete_all
    field :name, :string
    field :abbreviation, :string
    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct  \\ %__MODULE__{}, params \\ %{}) do
    IO.inspect params
    struct
    |> cast(params, [:name, :abbreviation])
    |> validate_required([:name])
  end
end
