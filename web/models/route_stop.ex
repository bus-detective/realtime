defmodule BdRt.RouteStop do
  use BdRt.Web, :model

  schema "route_stops" do
    belongs_to :route, BdRt.Route
    belongs_to :stop, BdRt.Stop
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [], [:route_id, :stop_id])
    |> foreign_key_constraint(:route_id)
    |> foreign_key_constraint(:stop_id)
  end
end
