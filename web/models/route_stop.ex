defmodule BdRt.RouteStop do
  use BdRt.Web, :model

  schema "route_stops" do
    belongs_to :route, BdRt.Route
    belongs_to :stop, BdRt.Stop
  end
end
