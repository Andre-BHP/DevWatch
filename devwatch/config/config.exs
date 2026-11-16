import Config

config :devwatch,
  namespace: DevWatch,
  ecto_repos: [DevWatch.Repo],
  generators: [timestamp_type: :utc_datetime_usec]

config :devwatch, DevWatchWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DevWatchWeb.ErrorHTML, json: DevWatchWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: DevWatch.PubSub

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
