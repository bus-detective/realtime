defmodule BdRt.ShapePoint do
  use BdRt.Web, :model

  schema "shape_points" do
    field :latitude, :float
    field :longitude, :float
    field :sequence, :integer
    field :distance_traveled, :float

    belongs_to :shape, BdRt.Shape

    timestamps inserted_at: :created_at
  end

  @required_fields ~w(latitude longitude sequence)
  @optional_fields ~w(distance_traveled shape_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:shape_id)
  end
end


