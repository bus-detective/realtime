defmodule BdRt.ServiceException do
  use BdRt.Web, :model

  schema "service_exceptions" do
    field :date, Ecto.Date
    field :exceptioon, :integer

    belongs_to :agency, BdRt.Agency
    belongs_to :service, BdRt.Service

    timestamps inserted_at: :created_at
  end

  @required_fields ~w(date exception)
  @optional_fields ~w(agency_id service_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:agency_id)
    |> foreign_key_constraint(:service_id)
  end
end

