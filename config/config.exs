import Config

config :doit,
  github_client: Doit.GitHub.Client.HTTP,
  todoist_client: Doit.Todoist.Client.HTTP,
  time_zone: "America/Los_Angeles"

config :elixir, time_zone_database: Tzdata.TimeZoneDatabase

import_config "#{Mix.env()}.exs"
