import Config

config :devwatch, DevWatchWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :devwatch, DevWatchWeb.Endpoint,
  force_ssl: [
    rewrite_on: [:x_forwarded_proto],
    hsts: true,
    exclude: [hosts: ["localhost", "127.0.0.1"]]
  ]

config :logger, level: :info
