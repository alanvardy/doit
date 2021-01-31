# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule Doit.Todoist.Client.Success do
  @moduledoc """
  Mock client for Todoist
  """
  alias Doit.Todoist.MockServer
  @behaviour Doit.Todoist.Client

  @impl true
  def create_task(task) do
    MockServer.put(task)
    :ok
  end

  @impl true
  def completed_items(arg, _), do: completed_items(arg)

  @impl true
  def completed_items(_) do
    {:ok,
     %{
       items: [
         %{
           "completed_date" => "2020-10-07T13:14:30Z",
           "content" =>
             "clearly state that your application is “not created by, affiliated with, or supported by Doist” in your application description.",
           "id" => 3_981_824_778,
           "meta_data" => nil,
           "project_id" => 2_245_606_904,
           "task_id" => 4_232_116_221,
           "user_id" => 635_166
         },
         %{
           "completed_date" => "2020-10-07T13:11:12Z",
           "content" => "Schedule talk with mom",
           "id" => 3_981_817_133,
           "meta_data" => nil,
           "project_id" => 2_244_228_141,
           "task_id" => 4_194_095_440,
           "user_id" => 635_166
         },
         %{
           "completed_date" => "2020-10-07T13:02:29Z",
           "content" =>
             "Do daily review [[link]](https://todoist.com/API/v8.7/import/totally_not_a_fake_link.csv)",
           "id" => 3_981_796_424,
           "meta_data" => nil,
           "project_id" => 2_242_998_504,
           "task_id" => 4_156_735_917,
           "user_id" => 635_166
         },
         %{
           "completed_date" => "2020-10-07T02:59:32Z",
           "content" => "Use middleware for change set errors",
           "id" => 3_980_887_569,
           "meta_data" => nil,
           "project_id" => 2_242_995_984,
           "task_id" => 4_218_522_382,
           "user_id" => 635_166
         },
         %{
           "completed_date" => "2020-10-07T02:15:37Z",
           "content" => "resolve subscription order issue",
           "id" => 3_980_839_191,
           "meta_data" => nil,
           "project_id" => 2_242_995_984,
           "task_id" => 4_226_372_315,
           "user_id" => 635_166
         },
         %{
           "completed_date" => "2020-10-07T02:02:24Z",
           "content" => "Resolve N +1 wallet fetching with `aggregate_balances/3`",
           "id" => 3_980_823_673,
           "meta_data" => nil,
           "project_id" => 2_242_995_984,
           "task_id" => 4_232_313_133,
           "user_id" => 635_166
         }
       ],
       projects: %{
         "2242995984" => %{
           "child_order" => 4,
           "collapsed" => 0,
           "color" => 42,
           "id" => 2_242_995_984,
           "is_archived" => 1,
           "is_deleted" => 0,
           "is_favorite" => 0,
           "name" => "Exchanger",
           "parent_id" => 2_242_997_747,
           "shared" => false,
           "sync_id" => nil
         },
         "2242998504" => %{
           "child_order" => 4,
           "collapsed" => 0,
           "color" => 40,
           "id" => 2_242_998_504,
           "is_archived" => 0,
           "is_deleted" => 0,
           "is_favorite" => 0,
           "name" => "⌨️  Code",
           "parent_id" => 2_242_997_804,
           "shared" => false,
           "sync_id" => nil
         },
         "2244228141" => %{
           "child_order" => 7,
           "collapsed" => 0,
           "color" => 39,
           "id" => 2_244_228_141,
           "is_archived" => 0,
           "is_deleted" => 0,
           "is_favorite" => 0,
           "name" => "🧍Relationships",
           "parent_id" => 2_242_997_804,
           "shared" => false,
           "sync_id" => nil
         },
         "2245606904" => %{
           "child_order" => 2,
           "collapsed" => 0,
           "color" => 47,
           "id" => 2_245_606_904,
           "is_archived" => 0,
           "is_deleted" => 0,
           "is_favorite" => 0,
           "name" => "doit",
           "parent_id" => 2_242_997_747,
           "shared" => false,
           "sync_id" => nil
         },
         "2246758292" => %{
           "child_order" => 4,
           "collapsed" => 0,
           "color" => 47,
           "id" => 2_246_758_292,
           "is_archived" => 0,
           "is_deleted" => 1,
           "is_favorite" => 1,
           "name" => "🔍 Daily Review",
           "parent_id" => nil,
           "shared" => false,
           "sync_id" => nil
         }
       }
     }}
  end

  @impl true
  def current_tasks() do
    {:ok,
     [
       %{
         "added_by_uid" => 635_166,
         "assigned_by_uid" => nil,
         "checked" => 0,
         "child_order" => 266,
         "collapsed" => 0,
         "content" =>
           "[some-repo](https://github.com/alanvardy/some-repo) -- Pull Request -- [Extend League Stats controller test. Adding get cached_playstyle_path…](https://github.com/alanvardy/some-repo/pull/2137)",
         "date_added" => "2021-01-29T23:05:20Z",
         "date_completed" => nil,
         "due" => nil,
         "id" => 4_535_839_657,
         "in_history" => 0,
         "is_deleted" => 0,
         "labels" => [],
         "note_count" => 0,
         "parent_id" => nil,
         "priority" => 2,
         "project_id" => 2_243_747_250,
         "responsible_uid" => nil,
         "section_id" => nil,
         "sync_id" => nil,
         "user_id" => 635_166
       },
       %{
         "added_by_uid" => 635_166,
         "assigned_by_uid" => nil,
         "checked" => 0,
         "child_order" => 267,
         "collapsed" => 0,
         "content" =>
           "[some-repo](https://github.com/alanvardy/some-repo) -- Pull Request -- [fix: move stricter credo back to shared_utils before anyone notices](https://github.com/alanvardy/some-repo/issues/2146#issuecomment-770097030)",
         "date_added" => "2021-01-29T23:08:28Z",
         "date_completed" => nil,
         "due" => nil,
         "id" => 4_535_844_967,
         "in_history" => 0,
         "is_deleted" => 0,
         "labels" => [],
         "note_count" => 0,
         "parent_id" => nil,
         "priority" => 2,
         "project_id" => 2_243_747_250,
         "responsible_uid" => nil,
         "section_id" => nil,
         "sync_id" => nil,
         "user_id" => 635_166
       },
       %{
         "added_by_uid" => 635_166,
         "assigned_by_uid" => nil,
         "checked" => 0,
         "child_order" => 270,
         "collapsed" => 0,
         "content" => "Last Week",
         "date_added" => "2021-01-30T08:10:54Z",
         "date_completed" => nil,
         "due" => nil,
         "id" => 4_536_411_772,
         "in_history" => 0,
         "is_deleted" => 0,
         "labels" => [],
         "note_count" => 2,
         "parent_id" => nil,
         "priority" => 2,
         "project_id" => 2_243_747_250,
         "responsible_uid" => nil,
         "section_id" => nil,
         "sync_id" => nil,
         "user_id" => 635_166
       },
       %{
         "added_by_uid" => 635_166,
         "assigned_by_uid" => nil,
         "checked" => 0,
         "child_order" => 273,
         "collapsed" => 0,
         "content" => "Last 24 Hours",
         "date_added" => "2021-01-31T14:40:25Z",
         "date_completed" => nil,
         "due" => nil,
         "id" => 4_539_174_784,
         "in_history" => 0,
         "is_deleted" => 0,
         "labels" => [],
         "note_count" => 5,
         "parent_id" => nil,
         "priority" => 2,
         "project_id" => 2_243_747_250,
         "responsible_uid" => nil,
         "section_id" => nil,
         "sync_id" => nil,
         "user_id" => 635_166
       }
     ]}
  end
end
