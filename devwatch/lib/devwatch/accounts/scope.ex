defmodule DevWatch.Accounts.Scope do
  @moduledoc """
  Alcance de quien hace la solicitud. Toda consulta de fichas recibe el alcance para buscar
  solo entre las de su cuenta (V10: si la ficha es de otra cuenta, se responde como si no
  existiera).
  """

  alias DevWatch.Accounts.Cuenta

  @type t :: %__MODULE__{cuenta: Cuenta.t()}

  defstruct cuenta: nil

  @doc "Crea el alcance de una cuenta, o nil si no hay cuenta."
  @spec para_cuenta(Cuenta.t() | nil) :: t() | nil
  def para_cuenta(%Cuenta{} = cuenta), do: %__MODULE__{cuenta: cuenta}
  def para_cuenta(nil), do: nil
end
