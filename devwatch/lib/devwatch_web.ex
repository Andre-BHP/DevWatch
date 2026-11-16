defmodule DevWatchWeb do
  @moduledoc """
  Punto de entrada de la interfaz web: controladores, plantillas HEEx y rutas verificadas.

  No se usan pantallas LiveView (V10, punto 10): las páginas son HTML convencional y la
  única actualización es una consulta periódica desde JavaScript.
  """

  def static_paths, do: ~w(css js favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      import Phoenix.HTML
      import DevWatchWeb.Componentes

      alias DevWatchWeb.Layouts

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: DevWatchWeb.Endpoint,
        router: DevWatchWeb.Router,
        statics: DevWatchWeb.static_paths()
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
