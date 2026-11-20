defmodule DevWatchWeb.RegistroController do
  use DevWatchWeb, :controller

  alias DevWatch.Accounts
  alias DevWatchWeb.Autenticacion

  def new(conn, _params) do
    render(conn, :new, form: Phoenix.Component.to_form(Accounts.cambiar_registro(), as: :cuenta))
  end

  def create(conn, %{"cuenta" => params}) do
    case Accounts.registrar_cuenta(params) do
      {:ok, cuenta} ->
        conn
        |> put_flash(:info, "Cuenta creada.")
        |> Autenticacion.iniciar_sesion(cuenta)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, form: Phoenix.Component.to_form(changeset, as: :cuenta))
    end
  end

  def create(conn, _params), do: create(conn, %{"cuenta" => %{}})
end
