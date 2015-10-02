defmodule BdRt.Collector.Runner do
  alias BdRt.Collector.Protobuf
  alias BdRt.Collector.Backend
  alias BdRt.Collector.VehiclePosition

  def collect do
    agencies |> Enum.each(&collect/1)
  end

  def collect(agency) do
    agency.feed_url
    |> Backend.fetch
    |> Protobuf.decode
    |> Stream.map(&VehiclePosition.extract_entity/1)
    |> Stream.map(&VehiclePosition.set_agency(agency, &1))
    |> Enum.to_list
  end

  defp agencies do
    BdRt.Repo.all(BdPro.Agency)
  end
end
