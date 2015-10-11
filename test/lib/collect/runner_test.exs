defmodule BdRt.Collector.RunnerTest do
  use ExUnit.Case, async: true
  use BdRt.ModelCase

  setup_all do
    Application.put_env :bd_rt, :collector_backend, BdRt.Collector.Backend.Fake
  end

  setup do
    {:ok, agency} = Repo.insert(%BdRt.Agency{name: "Metro", gtfs_vehicle_positions_url: "http://example.com"})
    {:ok, agency: agency}
  end

  test "collect with a specific agency", %{agency: agency} do
    results = BdRt.Collector.Runner.collect(agency)
    assert Enum.count(results) > 0
  end
end

