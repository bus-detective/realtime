defmodule BdRt.Service do
  use BdRt.Web, :model
  use Timex

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

  def for_time(time), do: for_time(time, __MODULE__)

  def for_time(time, query) do
    day_of_week = Date.weekday(Date.from(time)) |> Date.day_name |> String.downcase
    dow = String.to_atom(day_of_week)

    query = from s in query,
    where: ^time >= s.start_date and ^time <= s.end_date,
    where: field(s, ^dow) == true
  end
end


