defmodule DevWatch.AccountsTest do
  use DevWatch.DataCase, async: true

  import DevWatch.Fixtures

  alias DevWatch.Accounts
  alias DevWatch.Accounts.{Cuenta, Sesion}

  describe "registrar_cuenta/1 (RF-01 a RF-03)" do
    test "crea la cuenta y guarda solo la huella Argon2id de la contraseña" do
      {:ok, cuenta} =
        Accounts.registrar_cuenta(atributos_cuenta(%{"correo" => "ana@ejemplo.test"}))

      assert cuenta.nombre == "Persona de Prueba"
      assert cuenta.correo == "ana@ejemplo.test"
      assert cuenta.contrasena == nil
      assert "$argon2id$" <> _ = cuenta.huella_contrasena
      refute cuenta.huella_contrasena =~ contrasena_valida()
    end

    test "nombre, correo y contraseña son obligatorios" do
      {:error, changeset} = Accounts.registrar_cuenta(%{})

      assert errors_on(changeset) == %{
               nombre: ["El nombre es obligatorio"],
               correo: ["El correo es obligatorio"],
               contrasena: ["La contraseña es obligatoria"]
             }
    end

    test "rechaza un correo sin formato válido" do
      {:error, changeset} =
        Accounts.registrar_cuenta(atributos_cuenta(%{"correo" => "sin-arroba"}))

      assert errors_on(changeset).correo == ["El correo no tiene un formato válido"]
    end

    test "rechaza un correo que ya pertenece a otra cuenta, sin distinguir mayúsculas" do
      cuenta_fixture(%{"correo" => "repetido@ejemplo.test"})

      {:error, changeset} =
        Accounts.registrar_cuenta(atributos_cuenta(%{"correo" => "REPETIDO@ejemplo.test"}))

      assert errors_on(changeset).correo == ["El correo ya pertenece a otra cuenta"]
    end

    test "la contraseña admite exactamente de 12 a 128 caracteres" do
      mensaje = ["La contraseña debe tener entre 12 y 128 caracteres"]

      for {contrasena, esperado} <- [
            {String.duplicate("a", 11), mensaje},
            {String.duplicate("a", 12), nil},
            {String.duplicate("ñ", 128), nil},
            {String.duplicate("a", 129), mensaje}
          ] do
        changeset =
          Accounts.cambiar_registro(%Cuenta{}, atributos_cuenta(%{"contrasena" => contrasena}))

        assert Map.get(errors_on(changeset), :contrasena) == esperado,
               "longitud #{String.length(contrasena)}"
      end
    end
  end

  describe "obtener_cuenta_por_credenciales/2 (RF-04)" do
    test "devuelve la cuenta con correo y contraseña correctos" do
      cuenta = cuenta_fixture()

      assert %Cuenta{id: id} =
               Accounts.obtener_cuenta_por_credenciales(cuenta.correo, contrasena_valida())

      assert id == cuenta.id
    end

    test "devuelve nil con contraseña incorrecta o correo inexistente" do
      cuenta = cuenta_fixture()

      assert Accounts.obtener_cuenta_por_credenciales(cuenta.correo, "otra-contrasena-mala") ==
               nil

      assert Accounts.obtener_cuenta_por_credenciales("nadie@ejemplo.test", contrasena_valida()) ==
               nil

      assert Accounts.obtener_cuenta_por_credenciales(nil, nil) == nil
    end
  end

  describe "sesiones (RF-04, RF-05)" do
    test "una sesión identifica a su cuenta y al eliminarla deja de servir" do
      cuenta = cuenta_fixture()
      token = Accounts.crear_sesion(cuenta)

      assert byte_size(token) == 32
      assert Accounts.obtener_cuenta_por_sesion(token).id == cuenta.id

      assert Accounts.eliminar_sesion(token) == :ok
      assert Accounts.obtener_cuenta_por_sesion(token) == nil
      assert Repo.aggregate(Sesion, :count) == 0
    end

    test "un valor desconocido no identifica ninguna cuenta" do
      assert Accounts.obtener_cuenta_por_sesion(:crypto.strong_rand_bytes(32)) == nil
    end
  end
end
