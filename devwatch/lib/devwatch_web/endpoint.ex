defmodule DevWatchWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :devwatch

  # La sesión vive en una cookie firmada (V10, punto 10).
  @session_options [
    store: :cookie,
    key: "_devwatch_sesion",
    signing_salt: "q2d8LmVw",
    same_site: "Lax",
    http_only: true
  ]

  plug Plug.Static,
    at: "/",
    from: :devwatch,
    gzip: not code_reloading?,
    only: DevWatchWeb.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :devwatch
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  # Formularios del panel. El cuerpo JSON de /api se lee en su propio pipeline,
  # con el límite de 16,384 bytes de la V10 (ADR-004).
  plug Plug.Parsers,
    parsers: [:urlencoded],
    pass: ["*/*"]

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug DevWatchWeb.Router

  @doc false
  def session_options, do: @session_options
end
