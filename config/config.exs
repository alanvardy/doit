import Config

config :doit, github_client: Doit.GitHub.HTTPClient

import_config "#{Mix.env()}.exs"
