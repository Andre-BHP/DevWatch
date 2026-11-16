defmodule DevWatchWeb.ConnCase do
  @moduledoc """
  Caso de prueba para solicitudes HTTP. Cada prueba corre en el sandbox de la base de
  pruebas, así que sus cambios se deshacen al terminar.
  """

  use ExUnit.CaseTemplate

  alias DevWatch.Accounts.Scope

  using do
    quote do
      @endpoint DevWatchWeb.Endpoint

      use DevWatchWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import DevWatchWeb.ConnCase
      import DevWatch.Fixtures
    end
  end

  setup tags do
    DevWatch.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc "Registra una cuenta y deja la conexión con su sesión iniciada."
  def registrar_e_iniciar_sesion(%{conn: conn}) do
    cuenta = DevWatch.Fixtures.cuenta_fixture()

    %{
      conn: iniciar_sesion(conn, cuenta),
      cuenta: cuenta,
      scope: Scope.para_cuenta(cuenta)
    }
  end

  @doc "Inicia sesión con la cuenta dada en la conexión."
  def iniciar_sesion(conn, cuenta) do
    token = DevWatch.Accounts.crear_sesion(cuenta)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:token_sesion, token)
  end
end
