defmodule BdRt.StopTime do
  use BdRt.Web, :model

  schema "stop_times" do
    field :stop_headsign, :string
    field :pickup_type, :integer
    field :drop_off_type, :integer
    field :arrival_time, :string
    field :departure_time, :string # TODO: Create a custom interval type
    field :stop_sequence, :integer

    belongs_to :agency, BdRt.Agency
    belongs_to :trip, BdRt.Trip
    belongs_to :stop, BdRt.Stop

    timestamps inserted_at: :created_at
  end
end


