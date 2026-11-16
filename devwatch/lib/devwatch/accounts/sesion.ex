defmodule DevWatch.Accounts.Sesion do
  @moduledoc """
  Sesión: registro con un valor aleatorio asociado a la cuenta (V10, módulo de cuentas).

  El navegador guarda el valor en la cookie de sesión firmada de Phoenix. Cerrar sesión
  elimina el registro y el valor deja de servir.
  """
  use Ecto.Schema
  import Ecto.Query

  @type t :: %__MODULE__{}

  @bytes 32
  @vigencia_en_dias 14

  schema "sesiones" do
    field :token, :binary, redact: true
    belongs_to :cuenta, DevWatch.Accounts.Cuenta

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  @doc "Genera un valor aleatorio de 32 bytes y el registro que lo asocia a la cuenta."
  def construir(cuenta) do
    token = :crypto.strong_rand_bytes(@bytes)
    {token, %__MODULE__{token: token, cuenta_id: cuenta.id}}
  end

  @doc "Consulta la cuenta de un valor de sesión vigente."
  def consulta_cuenta(token) do
    from s in __MODULE__,
      join: c in assoc(s, :cuenta),
      where: s.token == ^token and s.inserted_at > ago(@vigencia_en_dias, "day"),
      select: c
  end

  @doc "Consulta las sesiones con un valor dado."
  def consulta_por_token(token), do: from(s in __MODULE__, where: s.token == ^token)
end
