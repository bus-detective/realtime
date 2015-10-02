defmodule BdRt.Collector.RunnerTest do
  use ExUnit.Case, async: true
  use BdRt.ModelCase

  setup_all do
    Application.put_env :bd_pro, :collector_backend, BdRt.Collector.Backend.Fake
  end

  setup do
    {:ok, agency} = Repo.insert(%BdRt.Agency{name: "Metro"})
    {:ok, agency: agency}
  end

  test "collect with a specific agency", %{agency: agency} do
    BdRt.Collector.Runner.collect(agency)

    count_query = from v in BdRt.VehiclePosition,
      where: v.agency_id == ^agency.id,
      select: count(v.id)

    assert Repo.one(count_query) > 0
  end

  test "collect for all agencies", %{agency: agency} do
    BdRt.Collector.Runner.collect

    count_query = from v in BdRt.VehiclePosition,
      where: v.agency_id == ^agency.id,
      select: count(v.id)

    assert Repo.one(count_query) > 0
  end
end

