import Config

config :doit,
  github_token: System.fetch_env!("GITHUB_TOKEN"),
  todoist_token: System.fetch_env!("TODOIST_TOKEN"),
  default_project: System.fetch_env!("DEFAULT_PROJECT")
