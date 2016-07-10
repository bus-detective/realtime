defmodule BdRt.Shape do
  use BdRt.Web, :model

  schema "shapes" do
    field :remote_id, :string

    belongs_to :agency, BdRt.Agency
    has_many :shape_points, BdRt.ShapePoint

    timestamps inserted_at: :created_at
  end

  @required_fields ~w(remote_id)
  @optional_fields ~w(agency_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:agency_id)
  end

  def coordinates(model) do
    # XXX: Does this work with an entity loaded from the DB?
    model.shape_points
    |> Enum.sort(&(&1.sequence < &2.sequence))
    |> Enum.map(fn(sp) -> [sp.latitude, sp.longitude] end)
  end
end


