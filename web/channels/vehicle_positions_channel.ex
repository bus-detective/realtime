defmodule BdRt.VehiclePositionsChannel do
  use Phoenix.Channel

  def join(<<"vehiclePosition:agency:", _agency_id :: size(32), ":trip:", _trip_id :: size(32)>>, _auth_msg, socket) do
    {:ok, socket}
  end
end
