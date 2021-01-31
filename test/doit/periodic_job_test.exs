defmodule Doit.PeriodicJobTest do
  use Doit.DataCase
  alias Doit.{PeriodicJob, Repo}
  alias Doit.Todoist.Client.BadResponse
  alias Doit.Todoist.Notification

  @saturday ~U[2020-10-10 12:00:00.178520Z]
  @tuesday ~U[2020-10-13 12:00:00.178520Z]

  setup do
    Repo.delete_all(Notification)
    :ok
  end

  describe "periodic job on a good Tuesday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @tuesday})

      :ok
    end

    test "sends a daily summary on Tuesdays" do
      Process.sleep(200)
      assert [%{type: :last_24}] = Repo.all(Notification)
    end
  end

  describe "periodic job on a bad Tuesday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @tuesday, client: BadResponse})

      :ok
    end

    test "doesn't create a notification record if it cannot send" do
      Process.sleep(200)
      assert [] = Repo.all(Notification)
    end
  end

  describe "periodic job on a good Saturday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @saturday})

      :ok
    end

    test "sends a weekly and daily summaries on Saturdays" do
      Process.sleep(200)
      assert [%{type: :last_week}, %{type: :last_24}] = Repo.all(Notification)
    end
  end

  describe "periodic job on a bad Saturday" do
    setup do
      start_supervised!({PeriodicJob, current_datetime: @saturday, client: BadResponse})

      :ok
    end

    test "doesn't create a notification record if it cannot send" do
      Process.sleep(200)
      assert [] = Repo.all(Notification)
    end
  end
end
