defmodule BdRt.Agency do
  use BdRt.Web, :model

  schema "agencies" do
    field :name, :string
    field :gtfs_vehicle_positions_url, :string
  end

  @required_fields ~w(name, gtfs_vehicle_positions_url)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def with_vehicle_postion_url do
    with_vehicle_postion_url(from a in __MODULE__)
  end

  def with_vehicle_postion_url(query) do
    from a in query,
    where: not is_nil(a.gtfs_vehicle_positions_url)
  end
end

