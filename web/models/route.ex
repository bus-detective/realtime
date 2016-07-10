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

  @required_fields ~w(remote_id)
  @optional_fields ~w(short_name long_name description route_type url text_color agency_id)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:agency_id)
  end
end
