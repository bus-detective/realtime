defmodule BdRt.ServiceException do
  use BdRt.Web, :model

  schema "service_exceptions" do
    field :date, Ecto.Date
    field :exceptioon, :integer

    belongs_to :agency, BdRt.Agency
    belongs_to :service, BdRt.Service

    timestamps inserted_at: :created_at
  end
end



