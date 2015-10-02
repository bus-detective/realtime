defmodule BdRt.Collector do
  use GenServer
  alias BdRt.Collector.Runner
  require Logger

  @interval 15_000

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init([]) do
    schedule_collect()
    {:ok, []}
  end

  def handle_info(:collect, _message) do
    Logger.info "Collecting Vehicle Positions"
    Runner.collect()
    |> Stream.map(&broadcast_vehicle_position/1)

    schedule_collect()
    {:noreply, nil}
  end

  def schedule_collect do
    Process.send_after(self(), :collect, @interval)
  end

  def broadcast_vehicle_position(vehicle_position) do
    BdRt.Endpoint.broadcast! topic(vehicle_position), "vehiclePositionUpdate", vehicle_position
  end

  def topic(vehicle_position) do
    agency_id = vehicle_position.agency_id
    trip_id = vehicle_position.trip_remote_id
    <<"vehiclePosition:agency", agency_id::size(32), ":trip:", trip_id:: size(16)>>
  end
end

