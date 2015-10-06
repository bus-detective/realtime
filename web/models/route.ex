defmodule BdRt.Route do
  use BdRt.Web, :model

  schema "routes" do
    field :remote_id, :string
    field :short_name, :string
    field :long_name, :string
    field :description, :string
    field :route_type, :integer
    field :url, :string
    field :text_color, :string

    belongs_to :agency, BdRt.Agency
    has_many :trips, BdRt.Trip

    timestamps inserted_at: :created_at
  end
end
