defmodule DevWatch.Fixtures do
  @moduledoc """
  Datos de prueba. Todos son ficticios (V10: las pruebas usan datos ficticios).
  """

  alias DevWatch.Accounts

  @contrasena_valida "contrasena-ficticia-12"

  def contrasena_valida, do: @contrasena_valida

  def correo_unico, do: "persona#{System.unique_integer([:positive])}@ejemplo.test"

  def atributos_cuenta(attrs \\ %{}) do
    Enum.into(attrs, %{
      "nombre" => "Persona de Prueba",
      "correo" => correo_unico(),
      "contrasena" => @contrasena_valida
    })
  end

  def cuenta_fixture(attrs \\ %{}) do
    {:ok, cuenta} = attrs |> atributos_cuenta() |> Accounts.registrar_cuenta()
    cuenta
  end
end
