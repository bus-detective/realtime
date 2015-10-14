defmodule BdRt.Ecto.Interval do
  @behaviour Ecto.Type
  defstruct [months: 0, days: 0, secs: 0]

  def type, do: :interval

  # Provide our own casting rules.
  def cast(<<hours::2-bytes, ?:, mins::2-bytes, ?:, secs::2-bytes>>),
    do: {:ok, %BdRt.Ecto.Interval{secs: to_i(hours) * 3600 + to_i(mins) * 60 + to_i(secs)}}
  def cast(%{"months" => months, "days" => days, "secs" => secs}),
    do: {:ok, %BdRt.Ecto.Interval{months: months, days: days, secs: secs}}
  def cast(%{months: months, days: days, secs: secs}),
    do: {:ok, %BdRt.Ecto.Interval{months: months, days: days, secs: secs}}
  def cast(%BdRt.Ecto.Interval{} = i),
    do: {:ok, i}
  def cast(_), do: :error

  # When loading data from the database, we are guaranteed to
  # receive an Postgrex.Interval (as database are stricts) and we will
  # just return it to be stored in the model struct.
  def load(%Postgrex.Interval{months: months, days: days, secs: secs}),
    do: {:ok, %BdRt.Ecto.Interval{months: months, days: days, secs: secs}}

  # When dumping data to the database, we *expect* an BdRt.Ecto.Interval
  # but any value could be inserted into the struct, so we need
  # guard against them.
  def dump(%BdRt.Ecto.Interval{months: months, days: days, secs: secs}),
    do: {:ok, %Postgrex.Interval{months: months, days: days, secs: secs}}
  def dump(_), do: :error

  defp to_i(nil), do: nil
  defp to_i(int) when is_integer(int), do: int
  defp to_i(bin) when is_binary(bin) do
    case Integer.parse(bin) do
      {int, ""} -> int
      _ -> nil
    end
  end
end
