defmodule BdRt.Shape do
  use BdRt.Web, :model

  schema "shapes" do
    field :remote_id, :string

    belongs_to :agency, BdRt.Agency

    timestamps inserted_at: :created_at
  end
end


