defmodule DevWatchWeb.PaginaController do
  use DevWatchWeb, :controller

  def inicio(conn, _params) do
    render(conn, :inicio)
  end
end
