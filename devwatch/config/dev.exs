import Config

# Credenciales solo de desarrollo local (ver .env.example y docs/adr/ADR-013).
config :devwatch, DevWatch.Repo,
  username: System.get_env("PGUSER", "devwatch"),
  password: System.get_env("PGPASSWORD", "devwatch_local"),
  hostname: System.get_env("PGHOST", "localhost"),
  database: "devwatch_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :devwatch, DevWatchWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "dev-only-secret-key-base-not-used-in-production-0123456789abcdef0123",
  watchers: []

config :devwatch, DevWatchWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(css|js)/.*\.(js|css)$"E,
      ~r"lib/devwatch_web/router\.ex$"E,
      ~r"lib/devwatch_web/(controllers|components)/.*\.(ex|heex)$"E
    ]
  ]

config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
