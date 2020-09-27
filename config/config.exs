import Config

config :doit,
  github_client: Doit.GitHub.Client.HTTP,
  todoist_client: Doit.Todoist.Client.HTTP

import_config "#{Mix.env()}.exs"
