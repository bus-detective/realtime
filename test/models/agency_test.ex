defmodule BdRt.AgencyTest do
  use BdRt.ModelCase

  alias BdRt.Agency

  @realtime_agency %Agency{ gtfs_trip_updates_url: 'http://example.com' }
  @non_realtime_agency %Agency{}

  test "agency with gtfs endpoint is considered realtime" do
    assert Agency.realtime?(@realtime_agency)
  end

  test "agency without gtfs endpoint is not considered realtime" do
    refute Agency.realtime?(@non_realtime_agency)
  end
end

