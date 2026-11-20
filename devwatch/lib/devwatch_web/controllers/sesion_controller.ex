defmodule DevWatchWeb.SesionController do
  use DevWatchWeb, :controller

  alias DevWatch.Accounts
  alias DevWatchWeb.Autenticacion

  def new(conn, _params) do
    render(conn, :new, form: Phoenix.Component.to_form(%{}, as: :sesion))
  end

  def create(conn, %{"sesion" => %{"correo" => correo, "contrasena" => contrasena}}) do
    if cuenta = Accounts.obtener_cuenta_por_credenciales(correo, contrasena) do
      Autenticacion.iniciar_sesion(conn, cuenta)
    else
      # No se revela si el correo existe.
      conn
      |> put_status(:unauthorized)
      |> put_flash(:error, "El correo o la contraseña no son correctos.")
      |> render(:new, form: Phoenix.Component.to_form(%{"correo" => correo}, as: :sesion))
    end
  end

  def create(conn, _params) do
    create(conn, %{"sesion" => %{"correo" => "", "contrasena" => ""}})
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Sesión cerrada.")
    |> Autenticacion.cerrar_sesion()
  end
end
