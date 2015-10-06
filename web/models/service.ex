defmodule BdRt.Service do
  use BdRt.Web, :model

  schema "services" do
    field :remote_id, :string
    field :monday, :boolean
    field :tuesday, :boolean
    field :wednesday, :boolean
    field :thursday, :boolean
    field :friday, :boolean
    field :saturday, :boolean
    field :sunday, :boolean
    field :start_date, Ecto.Date
    field :end_date, Ecto.Date

    belongs_to :agency, BdRt.Agency

    timestamps inserted_at: :created_at
  end
end


