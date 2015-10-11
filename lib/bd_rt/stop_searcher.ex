defmodule BdRt.StopSearcher do
  alias BdRt.SearchResult
  alias BdRt.Stop
  alias BdRt.TsqueryBuilder

  def search(params) do
    query = Stop.all
    if Dict.has_key?(params, :query) do
      query = Stop.search(query, TsqueryBuilder.build(Dict.get(params, :query)))
    end

    if Dict.has_key?(params, :longitude) && Dict.has_key?(params, :latitude) do
      query = Stop.by_distance(query, Dict.get(params, :latitude), Dict.get(params, :longitude))
    end

    results = query |> BdRt.Repo.all
    %SearchResult{results: results}
  end
end
