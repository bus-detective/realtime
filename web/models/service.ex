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

  @required_fields ~w(remote_id)
  @optional_fields ~w(monday tuesday wednesday thursday friday
  saturday sunday start_date end_date)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:agency_id)
  end

  def for_time(time), do: for_time(time, __MODULE__)
  def for_time(time, query) do
    day_of_week = Timex.weekday(Date.from(time)) |> Timex.day_name |> String.downcase
    dow = String.to_atom(day_of_week)

    from s in query,
    where: ^time >= s.start_date and ^time <= s.end_date,
    where: field(s, ^dow) == true
  end
end


