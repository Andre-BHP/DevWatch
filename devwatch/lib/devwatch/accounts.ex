defmodule DevWatch.Accounts do
  @moduledoc """
  Cuentas y sesiones (V10, módulo de cuentas y aplicaciones).
  """

  alias DevWatch.Accounts.{Cuenta, Sesion}
  alias DevWatch.Repo

  @doc "Registra una cuenta con nombre, correo y contraseña."
  @spec registrar_cuenta(map()) :: {:ok, Cuenta.t()} | {:error, Ecto.Changeset.t()}
  def registrar_cuenta(attrs) do
    %Cuenta{}
    |> Cuenta.registro_changeset(attrs)
    |> Repo.insert()
  end

  @doc "Changeset para el formulario de registro (no calcula la huella)."
  @spec cambiar_registro(Cuenta.t(), map()) :: Ecto.Changeset.t()
  def cambiar_registro(%Cuenta{} = cuenta \\ %Cuenta{}, attrs \\ %{}) do
    Cuenta.registro_changeset(cuenta, attrs, hash: false)
  end

  @doc "Devuelve la cuenta si el correo y la contraseña coinciden; nil en otro caso."
  @spec obtener_cuenta_por_credenciales(term(), term()) :: Cuenta.t() | nil
  def obtener_cuenta_por_credenciales(correo, contrasena)
      when is_binary(correo) and is_binary(contrasena) do
    cuenta = Repo.get_by(Cuenta, correo: String.trim(correo))
    if Cuenta.contrasena_valida?(cuenta, contrasena), do: cuenta
  end

  def obtener_cuenta_por_credenciales(_correo, _contrasena) do
    Cuenta.contrasena_valida?(nil, "")
    nil
  end

  @doc "Crea una sesión y devuelve su valor aleatorio."
  @spec crear_sesion(Cuenta.t()) :: binary()
  def crear_sesion(%Cuenta{} = cuenta) do
    {token, sesion} = Sesion.construir(cuenta)
    Repo.insert!(sesion)
    token
  end

  @doc "Cuenta asociada a un valor de sesión vigente, o nil."
  @spec obtener_cuenta_por_sesion(binary()) :: Cuenta.t() | nil
  def obtener_cuenta_por_sesion(token) when is_binary(token) do
    token |> Sesion.consulta_cuenta() |> Repo.one()
  end

  @doc "Elimina el registro de la sesión; el valor deja de servir."
  @spec eliminar_sesion(binary()) :: :ok
  def eliminar_sesion(token) when is_binary(token) do
    token |> Sesion.consulta_por_token() |> Repo.delete_all()
    :ok
  end
end
