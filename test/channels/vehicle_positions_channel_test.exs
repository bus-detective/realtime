defmodule BdRt.VehiclePositionsChannelTest do
  use ExUnit.Case, async: true
  use BdRt.ChannelCase

  setup do
    {:ok, socket} = connect(BdRt.AppSocket, %{})
    {:ok, _, socket} = subscribe_and_join(socket, "vehiclePosition:agency:1:trip:1234", %{})
    vehicle_position = %{lat: 1, long: 2, agency_id: 1, trip_remote_id: 1234}

    {:ok, socket: socket, vehicle_position: vehicle_position}
  end

  test "can subscribe to a socket and get messages", %{vehicle_position: vehicle_position} do
    BdRt.Collector.broadcast_vehicle_position(vehicle_position)

    assert_broadcast("vehiclePosition:update", vehicle_position)
  end
end

