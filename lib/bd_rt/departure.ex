defmodule BdRt.Departure do
  defstruct [:stop_time, :stop_time_update]

  # def duration_from(t) do
  #   %BdRt.Interval(time - t)
  # end

  def realtime?(%__MODULE__{stop_time_update: nil}), do: false
  def realtime?(%__MODULE__{}), do: true

  def time(departure) do
    realtime_time(departure) || scheduled_time(departure)
  end

  def realtime_time(%__MODULE__{stop_time_update: nil}), do: nil
  def realtime_time(%__MODULE__{stop_time_update: stop_time_update}), do: stop_time_update.departure_time

  def scheduled_time(departure) do
    departure.stop_time.departure_time
  end

  def delay(%__MODULE__{stop_time_update: nil}), do: 0
  def delay(%__MODULE__{stop_time_update: stop_time_update}), do: stop_time_update.delay
end
