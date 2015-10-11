defmodule BdRt.Stop do
  use BdRt.Web, :model

  schema "stops" do
    field :remote_id, :string
    field :code, :integer
    field :name, :string
    field :description, :string
    field :latitude, :float
    field :longitude, :float
    field :zone_id, :integer
    field :url, :string
    field :parent_station, :string

    belongs_to :agency, BdRt.Agency
    has_many :stop_times, BdRt.StopTime
    has_many :trips, BdRt.Trip

    timestamps inserted_at: :created_at
  end

  @direction_labels %{
    "i" => "inbound",
    "o" => "outbound",
    "n" => "northbound",
    "s" => "southbound",
    "e" => "eastbound",
    "w" => "westbound",
  }

  def direction(model) do
    Dict.get @direction_labels, String.last(model.remote_id)
  end

  def all do
    from st in __MODULE__
  end

  def search(ts_query_terms), do: search(__MODULE__, ts_query_terms)
  def search(query, ts_query_terms) do
    # Ecto is broken and you can't give a variable to fragment, so these have to be inline
    from st in query,
    where: fragment("to_tsvector('english', coalesce(?::text, '')) || to_tsvector('english', coalesce(?::text, '')) @@ to_tsquery('english', ?)", st.name, st.code, ^ts_query_terms),
    order_by: fragment("ts_rank(to_tsvector('english', coalesce(?::text, '')) || to_tsvector('english', coalesce(?::text, '')), to_tsquery('english', ?)) DESC", st.name, st.code, ^ts_query_terms)
  end

  def by_distance(lat, long), do: by_distance(__MODULE__, lat, long)
  def by_distance(query, lat, long) do
    rad_lat = deg_2_rads(lat)
    rad_long = deg_2_rads(long)
    earth_radius_miles = 1 / 1609.0

    from st in query,
    order_by: fragment("(ACOS(least(1,COS(?)*COS(?)*COS(RADIANS(latitude))*COS(RADIANS(longitude))+
          COS(?)*SIN(?)*COS(RADIANS(latitude))*SIN(RADIANS(longitude))+
          SIN(?)*SIN(RADIANS(latitude))))*?) ASC", ^rad_lat, ^rad_long, ^rad_lat, ^rad_long, ^rad_lat, ^earth_radius_miles)
  end

  defp deg_2_rads(degrees) when is_bitstring(degrees), do: deg_2_rads(String.to_float(degrees))
  defp deg_2_rads(degrees) when is_float(degrees) do
    degrees * :math.pi / 180
  end
end

