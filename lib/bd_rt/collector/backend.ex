defmodule BdRt.Collector.Backend do
  def fetch(uri), do: current_backend.fetch(uri)

  defp current_backend do
    Application.get_env(:bd_rt, :collector_backend) || BdRt.Collector.Backend.Real
  end
end

defmodule BdRt.Collector.Backend.Real do
  require Logger

  def fetch(uri) do
    Logger.debug "Fetching: #{uri}"
    HTTPoison.get!(uri).body
  end
end

defmodule BdRt.Collector.Backend.Fake do
  def fetch(_uri) do
    {:ok, file_contents} = File.read("test/fixtures/vehicle_positions_fixture.pb")
    file_contents
  end
end
