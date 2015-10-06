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
end


