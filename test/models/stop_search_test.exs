defmodule BdRt.StopSearchTest do
  use BdRt.ModelCase

  alias BdRt.Agency
  alias BdRt.Stop
  alias BdRt.TsqueryBuilder

  setup do
    {:ok, agency} = BdRt.Repo.insert(%Agency{})
    {:ok, stop} = BdRt.Repo.insert(%Stop{agency_id: agency.id, name: "Geoff's Stop"})

    {:ok, stop: stop }
  end

  test 'can find stops by name', %{stop: stop} do
    results = Stop.search(TsqueryBuilder.build(stop.name)) |> BdRt.Repo.all
    assert results == [stop]
  end
end
