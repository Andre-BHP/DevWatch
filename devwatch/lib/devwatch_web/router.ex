defmodule DevWatchWeb.Router do
  use DevWatchWeb, :router

  import DevWatchWeb.Autenticacion

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, html: {DevWatchWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" =>
        "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'"
    }

    plug :obtener_alcance
  end

  scope "/", DevWatchWeb do
    pipe_through :browser

    get "/", PaginaController, :inicio
  end

  scope "/", DevWatchWeb do
    pipe_through [:browser, :redirigir_si_hay_sesion]

    get "/registro", RegistroController, :new
    post "/registro", RegistroController, :create
    get "/iniciar-sesion", SesionController, :new
    post "/iniciar-sesion", SesionController, :create
  end

  scope "/", DevWatchWeb do
    pipe_through [:browser, :requerir_cuenta]

    delete "/cerrar-sesion", SesionController, :delete
  end
end
