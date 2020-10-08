import Config

config :doit,
  github_client: Doit.GitHub.Client.Local,
  todoist_client: Doit.Todoist.Client.Success,
  default_project: "123456789"
