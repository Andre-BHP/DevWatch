defmodule DevWatchWeb.CuentasControllerTest do
  use DevWatchWeb.ConnCase, async: true

  alias DevWatch.Accounts

  describe "registro" do
    test "muestra el formulario con los tres campos", %{conn: conn} do
      html = conn |> get(~p"/registro") |> html_response(200)
      assert html =~ "Crear cuenta"
      assert html =~ ~s(name="cuenta[nombre]")
      assert html =~ ~s(name="cuenta[correo]")
      assert html =~ ~s(name="cuenta[contrasena]")
    end

    test "crea la cuenta e inicia sesión", %{conn: conn} do
      conn =
        post(conn, ~p"/registro", %{"cuenta" => atributos_cuenta(%{"nombre" => "Ana Ficticia"})})

      assert redirected_to(conn) == ~p"/"

      html = conn |> recycle() |> get(~p"/") |> html_response(200)
      assert html =~ "Ana Ficticia"
      assert html =~ "Cerrar sesión"
    end

    test "con datos inválidos explica qué corregir", %{conn: conn} do
      conn =
        post(conn, ~p"/registro", %{
          "cuenta" => %{"nombre" => "", "correo" => "x", "contrasena" => "corta"}
        })

      html = html_response(conn, 422)
      assert html =~ "El nombre es obligatorio"
      assert html =~ "El correo no tiene un formato válido"
      assert html =~ "La contraseña debe tener entre 12 y 128 caracteres"
    end
  end

  describe "inicio y cierre de sesión" do
    test "inicia sesión con correo y contraseña", %{conn: conn} do
      cuenta = cuenta_fixture()

      conn =
        post(conn, ~p"/iniciar-sesion", %{
          "sesion" => %{"correo" => cuenta.correo, "contrasena" => contrasena_valida()}
        })

      assert redirected_to(conn) == ~p"/"
      assert is_binary(get_session(conn, :token_sesion))
    end

    test "con credenciales incorrectas no revela si el correo existe", %{conn: conn} do
      cuenta = cuenta_fixture()

      for correo <- [cuenta.correo, "nadie@ejemplo.test"] do
        html =
          conn
          |> post(~p"/iniciar-sesion", %{
            "sesion" => %{"correo" => correo, "contrasena" => "incorrecta-123"}
          })
          |> html_response(401)

        assert html =~ "El correo o la contraseña no son correctos."
      end
    end

    # PR-45: cerrar la sesión hace que el valor anterior ya no sirva.
    test "PR-45: cerrar sesión invalida el valor guardado", %{conn: conn} do
      cuenta = cuenta_fixture()
      conn = iniciar_sesion(conn, cuenta)
      token = get_session(conn, :token_sesion)

      conn = delete(conn, ~p"/cerrar-sesion")
      assert redirected_to(conn) == ~p"/"
      assert Accounts.obtener_cuenta_por_sesion(token) == nil

      # Reusar el valor anterior ya no identifica la cuenta.
      html =
        build_conn()
        |> init_test_session(%{token_sesion: token})
        |> get(~p"/")
        |> html_response(200)

      refute html =~ "Cerrar sesión"
      assert html =~ "Iniciar sesión"
    end

    test "con sesión iniciada, registro e inicio redirigen", %{conn: conn} do
      conn = iniciar_sesion(conn, cuenta_fixture())
      assert conn |> get(~p"/registro") |> redirected_to() == ~p"/"
      assert conn |> get(~p"/iniciar-sesion") |> redirected_to() == ~p"/"
    end

    test "cerrar sesión sin cuenta redirige a iniciar sesión", %{conn: conn} do
      assert conn |> delete(~p"/cerrar-sesion") |> redirected_to() == ~p"/iniciar-sesion"
    end
  end

  test "la página incluye la política de seguridad de contenido", %{conn: conn} do
    conn = get(conn, ~p"/")
    [csp] = get_resp_header(conn, "content-security-policy")
    assert csp =~ "script-src 'self'"
  end
end
