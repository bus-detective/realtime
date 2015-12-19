defmodule BdRt.DepartureFetcher do
  require Logger
  import Ecto.Query

  defstruct [:agency, :stop, :start_time, :end_time]

  def departures(df) do
    stop_times(df)
    |> Enum.map(fn(stop_time) -> %BdRt.Departure{stop_time: stop_time, stop_time_update: nil} end)
    |> Enum.sort_by(fn(st) -> st.time end)
  end

  def stop_times(df), do: stop_times(df.agency.id, df.stop.id, df.start_time, df.end_time)
  def stop_times(agency_id, stop_id, start_time, end_time) do
    query = CalculatedStopTime.between(start_time, end_time)
    BdRt.Repo.all from st in query,
    where: st.agency_id == ^agency_id and st.stop_id == ^stop_id,
    preload: [:stop, :trip, :route]
  end

  def valid?(%__MODULE__{agency: nil, stop: nil}), do: false
  def valid?(%__MODULE__{}), do: true

end

defmodule RealtimeDepartureFetcher do
  require Logger

  def departures(df) do
    found_times = DepartureFetcher.stop_times(df.agency.id, df.stop.id, query_start_time(df), df.end_time)
    updates = Enum.map(found_times, fn(stop_time) ->
      realtime_updates(df.agency)
      |> filter_for_stop_time(stop_time)
    end)
    Enum.zip(found_times, updates)
    |> Enum.map(fn({stop_time, stop_time_update}) -> %BdRt.Departure{stop_time: stop_time, stop_time_update: stop_time_update} end)
    |> Enum.sort_by(fn(st) -> st.time end)
    |> Enum.filter(&active?(df, &1))
  end

  # Realtime updates may shift the departures into the time window we are
  # asking for. Therefor we need to query further back in time in order capture
  # all the applicable departures.
  def query_start_time(departure_fetcher) do
    departure_fetcher.start_time - 1 #hour
  end

  def active?(df, departure) do
    departure.time >= df.start_time && departure.time <= df.end_time
  end

  def filter_for_stop_time(updates, stop_time) do
    # TODO: Filter
    updates
  end

  defp realtime_updates(agency) do
    # Non-standard memoization because we want to allow nulls so we don't
    # continually try and call the service
    try do
      nil # TODO: Metro.RealtimeUpdates.fetch(agency)
    rescue
      # e in Metro.Error ->
      e in RuntimeError ->
        Logger.warn(e)
        nil
    end
  end
end

