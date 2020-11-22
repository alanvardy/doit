defmodule Doit.TimeTest do
  use Doit.DataCase, async: true

  alias Doit.Time

  @days [
    {"Mon", ~U[2020-11-16 03:49:39.327762Z]},
    {"Tue", ~U[2020-11-17 03:49:39.327762Z]},
    {"Wed", ~U[2020-11-18 03:49:39.327762Z]},
    {"Thu", ~U[2020-11-19 03:49:39.327762Z]},
    {"Fri", ~U[2020-11-20 03:49:39.327762Z]},
    {"Sat", ~U[2020-11-21 03:49:39.327762Z]},
    {"Sun", ~U[2020-11-22 03:49:39.327762Z]}
  ]

  describe "day_of_week/1" do
    test "prints the correct day for date" do
      for {day, date} <- @days do
        assert Time.day_of_week(date) === day, "did not print #{day} for #{date}"
      end
    end
  end
end
