defmodule BdRt.CalculatedStopTimeTest do
  use BdRt.ModelCase

  alias BdRt.CalculatedStopTime
  alias BdRt.Ecto.Interval

  defmodule StopsOnDifferenDays do
    use BdRt.ModelCase
    setup do
      agency = insert(:agency)
      service = insert(:service, agency: agency, tuesday: true, wednesday: true)
      trip = insert(:trip, agency: agency, remote_id: "940135", service: service)
      stop = insert(:stop, agency: agency, remote_id: "HAMBELi")

      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("22:00:00"))
      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("23:00:00"))
      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("00:30:00"))
      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("01:00:00"))
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
      agency = insert(:agency)
      service = insert(:service, agency: agency, tuesday: true, wednesday: true)
      trip = insert(:trip, agency: agency, remote_id: "940135", service: service)
      stop = insert(:stop, agency: agency, remote_id: "HAMBELi")

      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("22:00:00"))
      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("23:00:00"))
      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("24:30:00"))
      insert(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.to_interval("25:00:00"))
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

      IO.inspect(Ecto.Adapters.SQL.to_sql(:all, BdRt.Repo, CalculatedStopTime.between(start_time, end_time)))

      assert Enum.count(stop_times) == 3
    end
  end

  def to_timestamp(time_str) do
    result = time_str
    |> Timex.Parse.DateTime.Parser.parse("{ISO}")

    case result do
      {:ok, dt} -> dt
      _ -> :error
    end
  end

end

