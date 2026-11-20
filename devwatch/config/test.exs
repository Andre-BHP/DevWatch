import Config

# Argon2 rápido solo en pruebas.
config :argon2_elixir, t_cost: 1, m_cost: 8

config :devwatch, DevWatch.Repo,
  username: System.get_env("PGUSER", "devwatch"),
  password: System.get_env("PGPASSWORD", "devwatch_local"),
  hostname: System.get_env("PGHOST", "localhost"),
  database: "devwatch_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :devwatch, DevWatchWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test-only-secret-key-base-not-used-in-production-0123456789abcdef01",
  server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
config :phoenix, sort_verified_routes_query_params: true
