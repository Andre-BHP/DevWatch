import Config

if System.get_env("PHX_SERVER") do
  config :devwatch, DevWatchWeb.Endpoint, server: true
end

config :devwatch, DevWatchWeb.Endpoint,
  http: [port: String.to_integer(System.get_env("PORT", "4000"))]

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "Falta la variable de entorno DATABASE_URL (ecto://USUARIO:CONTRASENA@HOST/BASE)."

  config :devwatch, DevWatch.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "Falta la variable de entorno SECRET_KEY_BASE (generar con mix phx.gen.secret)."

  host = System.get_env("PHX_HOST") || raise "Falta la variable de entorno PHX_HOST."

  config :devwatch, DevWatchWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}],
    secret_key_base: secret_key_base
end
