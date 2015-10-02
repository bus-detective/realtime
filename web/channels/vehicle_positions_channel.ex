defmodule BdRt.VehiclePositionsChannel do
  use Phoenix.Channel
  require Logger

  def join("vehiclePosition:" <> _etc, _msg, socket) do
    {:ok, socket}
  end

  def handle_in("vehiclePosition:update", vehicle_position, socket) do
    Logger.debug "Broadcasting vehicle position"
    broadcast! socket, "vehiclePosition:update", %{vehicle_position: vehicle_position}
    {:noreply, socket}
  end
end
