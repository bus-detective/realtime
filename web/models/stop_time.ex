defmodule BdRt.StopTime do
  use BdRt.Web, :model

  schema "stop_times" do
    field :stop_headsign, :string
    field :pickup_type, :integer
    field :drop_off_type, :integer
    field :arrival_time, BdRt.Ecto.Interval
    field :departure_time, BdRt.Ecto.Interval
    field :stop_sequence, :integer
    field :shape_dist_traveled, :float

    belongs_to :agency, BdRt.Agency
    belongs_to :trip, BdRt.Trip
    belongs_to :stop, BdRt.Stop

    timestamps inserted_at: :created_at
  end

  @required_fields ~w()
  @optional_fields ~w(stop_headsign pickup_type drop_off_type arrival_time
  departure_time stop_sequence shape_dist_traveled agency_id trip_id stop_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:agency_id)
    |> foreign_key_constraint(:trip_id)
    |> foreign_key_constraint(:stop_id)
  end
end


