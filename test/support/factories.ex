defmodule BdRt.Factories do
  use ExMachina.Ecto, repo: BdRt.Repo

  def agency_factory do
    %BdRt.Agency{
      name: "test",
      timezone: "America/New_York",
      language: "en",
      remote_id: "test",
      url: "http://example.com"
    }
  end

  def service_factory do
    %BdRt.Service{
      agency: build(:agency),
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      start_date: Timex.beginning_of_year(Timex.Date.now.year, "America/New_York"),
      end_date: Timex.end_of_year(Timex.Date.now.year, "America/New_York")
    }
  end

  def stop_factory do
    %BdRt.Stop{
      name: "Test Stop",
      agency: build(:agency),
      remote_id: sequence(:remote_id, &("TID#{&1}"))
    }
  end

  def stop_time_factory do
    %BdRt.StopTime{
      agency: build(:agency),
      stop: build(:stop),
      trip: build(:trip),
      departure_time: BdRt.Ecto.Interval.to_interval("22:00:00")
    }
  end

  def trip_factory do
    %BdRt.Trip{
      remote_id: sequence(:remote_id, &("TID#{&1}")),
      service: build(:service)
    }
  end
end
