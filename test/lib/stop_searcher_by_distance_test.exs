defmodule BdRt.StopSearchByDistanceTest do
  use BdRt.ModelCase

  alias BdRt.Stop
  alias BdRt.StopSearcher

  setup do
    {:ok, far_stop} = BdRt.Repo.insert(%Stop{latitude: 38.104836, longitude: -85.511653})
    {:ok, near_stop} = BdRt.Repo.insert(%Stop{latitude: 39.104836, longitude: -84.511653})

    {:ok, far_stop: far_stop, near_stop: near_stop}
  end

  test "with a single word returns only the matching stop", %{far_stop: far_stop, near_stop: near_stop} do
    params = %{ latitude: "39.1043200", longitude: "-84.5118910" }
    search_result = StopSearcher.search(params)
    assert search_result.results == [near_stop, far_stop]
  end
end
