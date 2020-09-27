import Config

config :doit, github_client: Doit.GitHub.Client.HTTP

import_config "#{Mix.env()}.exs"
