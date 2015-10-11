defmodule BdRt.TsqueryBuilder do
  alias BdRt.Ordinalize

  # This is basically not tennable. We could, in theory, have streets into the hundreds
  # where people would do fiftieth or 50th
  @sub_static [
    ["alley", "aly"],
    ["avenue", "ave"],
    ["boulevard", "blvd"],
    ["court", "ct"],
    ["circle", "cir"],
    ["expressway", "expy", "exp"],
    ["freeway", "fwy"],
    ["highway", "hwy"],
    ["lane", "ln"],
    ["place", "pl"],
    ["parkway", "pkwy"],
    ["road", "rd"],
    ["route", "rte"],
    ["square", "sq", "sqr"],
    ["street", "st", "str"],
  ]

  @substitutions Enum.reduce(1..99, @sub_static, fn(i, accum) ->
    accum ++ [[Integer.to_string(i), Ordinalize.englishize(i), Ordinalize.ordinalize(i)]]
  end)

  # Preprocess the above so we can just look up by a key
  @substitution_map Enum.reduce(@substitutions, %{}, fn(ts, map) ->
    Enum.reduce(ts, map, fn(term, accum) -> Dict.put(accum, term, ts) end) end)

  def build(nil) do
    nil
  end

  def build(query) do
    # Space around and below is important so that a word containing "and" isn"t split
    query
    |> String.downcase
    |> String.split(~r{&| and })
    |> Enum.map(&String.strip/1)
    |> Enum.map(&build_ts_query/1)
    |> Enum.map(fn(q)-> "(#{q})" end)
    |> Enum.join(" & ")
  end

  defp build_ts_query(query) do
    String.split(query, " ")
    |> Enum.map(&expand/1)
    |> Enum.join(" & ")
  end

  defp expand(term) do
    case Dict.fetch(@substitution_map, term) do
      {:ok, ts} -> "(#{Enum.join(ts, " | ")})"
      _ -> term
    end
  end
end
