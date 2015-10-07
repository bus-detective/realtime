defmodule BdRt.Shape do
  use BdRt.Web, :model

  schema "shapes" do
    field :remote_id, :string

    belongs_to :agency, BdRt.Agency
    has_many :shape_points, BdRt.ShapePoint

    timestamps inserted_at: :created_at
  end

  def coordinates(model) do
    # XXX: Does this work with an entity loaded from the DB?
    Enum.sort(model.shape_points, &(&1.sequence < &2.sequence))
    |> Enum.map fn(sp) -> [sp.latitude, sp.longitude] end
  end
end


