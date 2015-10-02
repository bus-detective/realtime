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
    agencies
    |> Enum.map(&Runner.collect/1)
    |> Enum.each(&broadcast_vehicle_positions/1)

    schedule_collect()
    {:noreply, nil}
  end

  def schedule_collect do
    Process.send_after(self(), :collect, @interval)
  end

  defp agencies do
    BdRt.Agency.with_vehicle_postion_url
    |> BdRt.Repo.all
  end

  def broadcast_vehicle_positions(vehicle_positions) do
    Enum.each(vehicle_positions, &broadcast_vehicle_position/1)
  end


  def broadcast_vehicle_position(vehicle_position) do
    BdRt.Endpoint.broadcast! "vehiclePosition" <> sub_topic(vehicle_position), "vehiclePosition:update", vehicle_position
  end

  def sub_topic(vehicle_position) do
    agency_id = vehicle_position.agency_id
    trip_id = vehicle_position.trip_remote_id
    "agency:#{agency_id}:trip:#{trip_id}"
  end
end

