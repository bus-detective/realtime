defmodule BdRt.CalculatedStopTime do
  alias BdRt.StopTime

  import Ecto.Query

  def between(start_time, end_time), do: between(StopTime, start_time, end_time)
  def between(query, start_time, end_time) do
    query
    |> joins_times(start_time, end_time)
    |> where([st, a, t, es], fragment("(start_time(?) + ?) BETWEEN (? AT TIME ZONE ?) AND (? AT TIME ZONE ?)", es.date, st.departure_time, ^start_time, a.timezone, ^end_time, a.timezone))
    |> order_by([st, a, t, es], fragment("start_time(?) + ?", es.date, st.departure_time))
  end

  # Effective services are those that are the the normal services for trips
  # where service exceptions are also taken into account
  # The first part of the union is for additions (exception = 1 is an added
  # services)
  # The second half of the union is for normal services that are not removed
  # (either no exception or an exception that is not 2) (exception = 2 is a
  # removed service)
  def joins_times(start_time, end_time), do: joins_times(StopTime, start_time, end_time)
  def joins_times(query, start_time, end_time) do
    query
    |> join(:inner, [st], a in BdRt.Agency, st.agency_id == a.id)
    |> join(:inner, [st, a], t in BdRt.Trip, st.trip_id == t.id)
    |> join(:inner, [st, a, t], es in fragment("(SELECT * FROM effective_services(?, ?))", ^start_time, ^end_time), t.service_id == es.service_id)
  end
end
