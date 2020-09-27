import Config

config :doit,
  github_client: Doit.GitHub.Client.Local,
  todoist_client: Doit.Todoist.Client.Local,
  default_project: "123456789"
