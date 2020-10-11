defmodule Doit.Time do
  @moduledoc """
  Handles time conversion and pretty printing
  """
  @time_zone Application.get_env(:doit, :time_zone)

  @type timestamp :: String.t()

  @spec humanize(DateTime.t()) :: String.t()
  def humanize(datetime) do
    datetime = to_local(datetime)
    %{year: year, month: month, day: day, hour: hour, minute: minute} = datetime

    day_of_week = day_of_week(datetime)

    """
    #{year}-#{zero_pad(month)}-#{zero_pad(day)} - \
    #{day_of_week} - \
    #{zero_pad(hour)}:#{zero_pad(minute)}\
    """
  end

  @spec timestamp_to_datetime(timestamp) :: DateTime.t()
  def timestamp_to_datetime(timestamp) do
    {:ok, datetime, 0} = DateTime.from_iso8601(timestamp)
    datetime
  end

  @spec datetime_to_timestamp(DateTime.t()) :: timestamp
  def datetime_to_timestamp(datetime) do
    %{year: year, month: month, day: day, hour: hour, minute: minute} = datetime

    "#{year}-#{zero_pad(month)}-#{zero_pad(day)}T#{zero_pad(hour)}:#{zero_pad(minute)}"
  end

  defp day_of_week(%DateTime{} = datetime) do
    datetime
    |> DateTime.to_date()
    |> Date.day_of_week()
    |> case do
      1 -> "Mon"
      2 -> "Tue"
      3 -> "Wed"
      4 -> "Thu"
      5 -> "Fri"
      6 -> "Sat"
      7 -> "Sun"
    end
  end

  defp to_local(%DateTime{} = datetime) do
    DateTime.shift_zone!(datetime, @time_zone)
  end

  defp zero_pad(number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
