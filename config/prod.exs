import Config

config :doit,
  # Get your GitHub token here: https://github.com/settings/tokens
  github_token: System.fetch_env!("GITHUB_TOKEN"),
  # Get Todoist API token here: https://todoist.com/prefs/integrations
  todoist_token: System.fetch_env!("TODOIST_TOKEN"),
  # Go to your Todoist project in a web browser, it will be the final digits in the url
  default_project: System.fetch_env!("DEFAULT_PROJECT")
