defmodule BdRt.Collector.VehiclePosition do
  use Timex

  def extract_entity(entity) do
    %{
      lat: entity.vehicle.position.latitude,
      lng: entity.vehicle.position.longitude,
      vehicle_remote_id: entity.id,
      trip_remote_id: entity.vehicle.trip.trip_id,
      timestamp: entity.vehicle.timestamp
    }
  end

  def set_agency(agency, vehicle_position_changeset) do
    Dict.put(vehicle_position_changeset, :agency_id, agency.id)
  end
end
