defmodule BdRt.Trip do
  use BdRt.Web, :model

  schema "trips" do
    field :remote_id, :string
    field :headsign, :string
    field :short_name, :string
    field :direction_id, :integer
    field :block_id, :integer
    field :wheelchair_accessible, :boolean
    field :bikes_allowed, :boolean

    belongs_to :agency, BdRt.Agency
    belongs_to :route, BdRt.Route
    belongs_to :service, BdRt.Service
    belongs_to :shape, BdRt.Shape

    timestamps inserted_at: :created_at
  end
end

