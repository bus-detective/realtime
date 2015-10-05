defmodule BdRt.VehiclePositionsChannel do
  use Phoenix.Channel
  require Logger

  intercept ["vehiclePosition:update"]

  def join("vehiclePosition:" <> _etc, _msg, socket) do
    {:ok, socket}
  end

  def handle_out(event, vehicle_position, socket) do
    Logger.debug "Broadcasting #{event}"

    push socket, event, vehicle_position
    {:noreply, socket}
  end
end
