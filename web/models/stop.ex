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

  @direction_labels %{
    "i" => "inbound",
    "o" => "outbound",
    "n" => "northbound",
    "s" => "southbound",
    "e" => "eastbound",
    "w" => "westbound",
  }

  def direction(model) do
    Dict.get @direction_labels, String.last(model.remote_id)
  end
end



