defmodule BdRt.CalculatedStopTimeTest do
  use BdRt.ModelCase

  alias BdRt.CalculatedStopTime
  alias BdRt.Agency
  alias BdRt.Service
  alias BdRt.Trip
  alias BdRt.Stop
  alias BdRt.StopTime

  defmodule StopsOnDifferenDays do
    use BdRt.ModelCase
    setup do
      {:ok, agency} = BdRt.Repo.insert(%Agency{name: "test"})
      {:ok, service} = BdRt.Repo.insert(%Service{agency_id: agency.id, tuesday: true, wednesday: true})
      {:ok, trip} = BdRt.Repo.insert(%Trip{agency_id: agency.id, remote_id: "940135", service_id: service.id})
      {:ok, stop} = BdRt.Repo.insert(%Stop{agency_id: agency.id, remote_id: "HAMBELi"})

      {:ok, _} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "22:00:00")})
      {:ok, _} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "23:00:00")})
      {:ok, _} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "00:30:00")})
      {:ok, _} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "01:00:00")})
      :ok
    end

    test "requesting stops on the same day can find those stops" do
      start_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-12T22:00:00-0400")
      end_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-12T23:30:00-0400")
      stop_times = CalculatedStopTime.between(start_time, end_time) |> BdRt.Repo.all
      assert Enum.count(stop_times) == 2
    end

    test "having stops that cross the local time day boundary can find those stops" do
      start_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-12T23:00:00-0400")
      end_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-13T01:30:00-0400")
      stop_times = CalculatedStopTime.between(start_time, end_time) |> BdRt.Repo.all
      assert Enum.count(stop_times) == 3
    end
  end

  defmodule StopsOnSameDays do
    use BdRt.ModelCase
    setup do
      {:ok, agency} = BdRt.Repo.insert(%Agency{name: "test"})
      {:ok, service} = BdRt.Repo.insert(%Service{agency_id: agency.id, tuesday: true, wednesday: true})
      {:ok, trip} = BdRt.Repo.insert(%Trip{agency_id: agency.id, remote_id: "940135", service_id: service.id})
      {:ok, stop} = BdRt.Repo.insert(%Stop{agency_id: agency.id, remote_id: "HAMBELi"})

      {:ok, stop_time1} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "22:00:00")})
      {:ok, stop_time2} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "23:00:00")})
      {:ok, stop_time3} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "24:30:00")})
      {:ok, stop_time4} = BdRt.Repo.insert(%StopTime{agency_id: agency.id, stop_id: stop.id, trip_id: trip.id, departure_time: Ecto.Type.cast(BdRt.Ecto.Interval, "25:00:00")})
      :ok
    end

    test "requesting stops on the same day can find those stops" do
      start_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-12T22:00:00-0400")
      end_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-12T23:30:00-0400")
      stop_times = CalculatedStopTime.between(start_time, end_time) |> BdRt.Repo.all
      assert Enum.count(stop_times) == 2
    end

    test "having stops that cross the local time day boundary can find those stops" do
      start_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-12T23:00:00-0400")
      end_time = BdRt.CalculatedStopTimeTest.to_timestamp("2015-05-13T01:30:00-0400")
      stop_times = CalculatedStopTime.between(start_time, end_time) |> BdRt.Repo.all
      assert Enum.count(stop_times) == 3
    end
  end

  def to_timestamp(time_str) do
    time_str
    |> Timex.DateFormat.parse!("{ISO}")
    |> Timex.Date.Convert.to_gregorian
  end

end

