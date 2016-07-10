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

  @required_fields ~w(remote_id)
  @optional_fields ~w(headsign short_name direction_id block_id
  wheelchair_accessible bikes_allowed agency_id route_id service_id shape_id)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:agency_id)
    |> foreign_key_constraint(:route_id)
    |> foreign_key_constraint(:service_id)
    |> foreign_key_constraint(:shape_id)
  end
end

