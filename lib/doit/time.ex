defmodule Doit.Time do
  @moduledoc """
  Handles time conversion and pretty printing
  """
  @time_zone Application.compile_env(:doit, :time_zone)
  @twenty_four_hours_ago -60 * 60 * 24
  @one_week_ago @twenty_four_hours_ago * 7

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

  @spec get_datetime(:last_24 | :last_week) :: DateTime.t()
  def get_datetime(:last_24), do: DateTime.add(DateTime.utc_now(), @twenty_four_hours_ago)
  def get_datetime(:last_week), do: DateTime.add(DateTime.utc_now(), @one_week_ago)

  @spec today?(DateTime.t()) :: boolean
  @spec today?(DateTime.t(), keyword) :: boolean
  def today?(datetime, opts \\ []) do
    with nil <- Keyword.get(opts, :current_datetime),
         true <- to_local_date(datetime) == to_local_date(DateTime.utc_now()) do
      true
    else
      false -> false
      # Test override
      %DateTime{} -> true
    end
  end

  @spec saturday? :: boolean
  @spec saturday?(keyword) :: boolean
  def saturday?(opts \\ []) do
    opts
    |> Keyword.get(:current_datetime, DateTime.utc_now())
    |> to_local_date()
    |> Date.day_of_week()
    |> Kernel.==(6)
  end

  @spec day_of_week(DateTime.t()) :: String.t()
  def day_of_week(%DateTime{} = datetime) do
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

  defp to_local_date(%DateTime{} = datetime) do
    datetime |> to_local() |> DateTime.to_date()
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
