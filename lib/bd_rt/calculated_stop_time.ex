defmodule BdRt.CalculatedStopTime do
  defstruct [:id, :stop_sequence, :stop_headsign, :pickup_type,
   :drop_off_type, :shape_dist_traveled, :agency_id, :stop_id, :trip_id,
   :arrival_time, :departure_time]

  alias BdRt.StopTime

  import Ecto.Query

  # FIXME: Ecto isn't mature enough: https://github.com/elixir-lang/ecto/issues/1010

  # Effective services are those that are the the normal services for trips
  # where service exceptions are also taken into account
  # The first part of the union is for additions (exception = 1 is an added
  # services)
  # The second half of the union is for normal services that are not removed
  # (either no exception or an exception that is not 2) (exception = 2 is a
  # removed service)
  def between(start_time, end_time), do: between(StopTime, start_time, end_time)
  def between(query, start_time, end_time) do
    {start_date, _} = start_time |> Timex.to_erlang_datetime
    {end_date, _} = end_time |> Timex.to_erlang_datetime

    start_time = Timex.Timezone.convert(start_time, Timex.timezone("UTC", Timex.DateTime.today)) |> Timex.format!("{ISO}")
    end_time = Timex.Timezone.convert(end_time, Timex.timezone("UTC", Timex.DateTime.today)) |> Timex.format!("{ISO}")

    from st in query,
    join: a in assoc(st, :agency),
    join: t in assoc(st, :trip),
    join: es in fragment("SELECT * FROM effective_services(?, ?)", ^start_date, ^end_date), on: es.service_id == t.service_id,
    where: fragment("(start_time(?) + ?) BETWEEN (date(?::text) AT TIME ZONE ?) AND (date(?::text) AT TIME ZONE ?)", es.date, st.departure_time, ^start_time, a.timezone, ^end_time, a.timezone),
    order_by: fragment("start_time(?) + ?", es.date, st.departure_time),
    select: [st.id, st.stop_sequence, st.stop_headsign, st.pickup_type, st.drop_off_type, st.shape_dist_traveled, st.agency_id, st.stop_id, st.trip_id,
          fragment("to_char(((start_time(?) + ?) AT TIME ZONE 'UTC'), 'YYYY-MM-DD HH24:MI:SS') as arrival_time", es.date, st.arrival_time),
          fragment("to_char(((start_time(?) + ?) AT TIME ZONE 'UTC'), 'YYYY-MM-DD HH24:MI:SS') as departure_time", es.date, st.departure_time)]
  end
end
