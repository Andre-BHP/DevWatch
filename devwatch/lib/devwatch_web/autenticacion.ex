defmodule DevWatchWeb.Autenticacion do
  @moduledoc """
  Plugs de sesión: identifica la cuenta en cada solicitud con el valor guardado en la cookie
  firmada, inicia y cierra sesión, y protege las rutas que exigen una cuenta.
  """
  use DevWatchWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias DevWatch.Accounts
  alias DevWatch.Accounts.Scope

  @clave_sesion :token_sesion

  @doc "Crea la sesión de la cuenta y la redirige al destino guardado o al listado."
  def iniciar_sesion(conn, cuenta) do
    token = Accounts.crear_sesion(cuenta)
    destino = get_session(conn, :volver_a)

    conn
    |> renovar_sesion()
    |> put_session(@clave_sesion, token)
    |> redirect(to: destino || ruta_con_sesion())
  end

  @doc "Elimina el registro de la sesión y limpia la cookie."
  def cerrar_sesion(conn) do
    if token = get_session(conn, @clave_sesion), do: Accounts.eliminar_sesion(token)

    conn
    |> renovar_sesion()
    |> redirect(to: ~p"/")
  end

  @doc "Asigna `current_scope` con la cuenta de la sesión, o nil."
  def obtener_alcance(conn, _opts) do
    cuenta =
      case get_session(conn, @clave_sesion) do
        token when is_binary(token) -> Accounts.obtener_cuenta_por_sesion(token)
        _ -> nil
      end

    assign(conn, :current_scope, Scope.para_cuenta(cuenta))
  end

  @doc "Exige una cuenta; si no hay, redirige a iniciar sesión."
  def requerir_cuenta(conn, _opts) do
    if conn.assigns[:current_scope] do
      conn
    else
      conn
      |> put_flash(:error, "Inicia sesión para continuar.")
      |> guardar_destino()
      |> redirect(to: ~p"/iniciar-sesion")
      |> halt()
    end
  end

  @doc "Si ya hay sesión, no muestra registro ni inicio de sesión."
  def redirigir_si_hay_sesion(conn, _opts) do
    if conn.assigns[:current_scope] do
      conn |> redirect(to: ruta_con_sesion()) |> halt()
    else
      conn
    end
  end

  @doc "Ruta a la que se llega después de iniciar sesión."
  def ruta_con_sesion, do: ~p"/"

  defp renovar_sesion(conn) do
    delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp guardar_destino(%{method: "GET"} = conn),
    do: put_session(conn, :volver_a, current_path(conn))

  defp guardar_destino(conn), do: conn
end
