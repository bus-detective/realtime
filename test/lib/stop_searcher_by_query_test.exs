defmodule BdRt.StopSearchByQueryTest do
  use BdRt.ModelCase

  alias BdRt.Stop
  alias BdRt.StopSearcher

  setup do
    {:ok, matching_stop} = BdRt.Repo.insert(%Stop{name: "8th & Walnut", code: 1234})
    {:ok, non_matching_stop} = BdRt.Repo.insert(%Stop{name: "7th & Main", code: 456})

    {:ok, matching_stop: matching_stop, non_matching_stop: non_matching_stop}
  end

  test "with a single word returns only the matching stop", %{matching_stop: matching_stop} do
    params = %{ query: "walnut" }
    search_result = StopSearcher.search(params)
    assert search_result.results == [matching_stop]
  end

  test "with multiple words returns only the matching stop", %{matching_stop: matching_stop} do
    params = %{ query: "walnut 8th" }
    search_result = StopSearcher.search(params)
    assert search_result.results == [matching_stop]
  end

  test "with a 'and' instead of '&' returns only the mating stop", %{matching_stop: matching_stop} do
    params = %{ query: "8th and walnut" }
    search_result = StopSearcher.search(params)
    assert search_result.results == [matching_stop]
  end

  test "with a spelled out street returns only the matching stop", %{matching_stop: matching_stop} do
    params = %{ query: "eighth" }
    search_result = StopSearcher.search(params)
    assert search_result.results == [matching_stop]
  end

  test "with a stop code returns only the matching stop", %{matching_stop: matching_stop} do
    params = %{ query: "1234" }
    search_result = StopSearcher.search(params)
    assert search_result.results == [matching_stop]
  end
end
