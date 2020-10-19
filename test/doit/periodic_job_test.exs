defmodule Doit.PeriodicJobTest do
  use Doit.DataCase
  alias Doit.{PeriodicJob, Repo}
  alias Doit.Todoist.Client.BadResponse
  alias Doit.Todoist.Notification

  @monday %DateTime{DateTime.utc_now() | year: 2020, month: 10, day: 12}
  @tuesday %DateTime{@monday | day: 13}

  describe "Periodic job on a good Tuesday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @tuesday})

      :ok
    end

    test "Sends a daily summary on Tuesdays" do
      Process.sleep(200)
      assert [%{type: :last_24}] = Repo.all(Notification)
    end
  end

  describe "Periodic job on a bad Tuesday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @tuesday, client: BadResponse})

      :ok
    end

    test "Doesn't create a notification record if it cannot send" do
      Process.sleep(200)
      assert [] = Repo.all(Notification)
    end
  end

  describe "Periodic job on a good Monday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @monday})

      :ok
    end

    test "Sends a weekly and daily summaries on Mondays" do
      Process.sleep(200)
      assert [%{type: :last_week}, %{type: :last_24}] = Repo.all(Notification)
    end
  end

  describe "Periodic job on a bad Monday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @monday, client: BadResponse})

      :ok
    end

    test "Doesn't create a notification record if it cannot send" do
      Process.sleep(200)
      assert [] = Repo.all(Notification)
    end
  end
end
