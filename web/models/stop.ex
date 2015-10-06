defmodule BdRt.Stop do
  use BdRt.Web, :model

  schema "stops" do
    field :remote_id, :string
    field :code, :string
    field :name, :string
    field :description, :string
    field :latitude, :float
    field :longitude, :float
    field :zone_id, :integer
    field :url, :string
    field :parent_station, :string

    belongs_to :agency, BdRt.Agency
    has_many :stop_times, BdRt.StopTime
    has_many :trips, BdRt.Trip

    timestamps inserted_at: :created_at
  end
end



