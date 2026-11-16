defmodule DevWatchWeb.Componentes do
  @moduledoc """
  Componentes HTML propios (sin librerías de UI). Usan los tokens de `DESIGN.md`.
  """
  use Phoenix.Component

  @doc "Mensajes flash de información y error."
  attr :flash, :map, required: true

  def mensajes(assigns) do
    ~H"""
    <div id="mensajes" aria-live="polite">
      <div :if={msg = Phoenix.Flash.get(@flash, :info)} class="aviso aviso--info" role="status">
        <p>{msg}</p>
      </div>
      <div :if={msg = Phoenix.Flash.get(@flash, :error)} class="aviso aviso--error" role="alert">
        <p>{msg}</p>
      </div>
    </div>
    """
  end

  @doc """
  Campo de formulario con etiqueta visible, ayuda opcional y errores del changeset.
  """
  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true
  attr :type, :string, default: "text"
  attr :ayuda, :string, default: nil
  attr :rest, :global, include: ~w(autocomplete required maxlength minlength min max step)

  def campo(assigns) do
    errores = if Phoenix.Component.used_input?(assigns.field), do: assigns.field.errors, else: []
    assigns = assign(assigns, :errores, Enum.map(errores, &traducir_error/1))

    ~H"""
    <div class={["campo", @errores != [] && "campo--error"]}>
      <label for={@field.id}>{@label}</label>
      <input
        type={@type}
        id={@field.id}
        name={@field.name}
        value={
          if @type == "password",
            do: nil,
            else: Phoenix.HTML.Form.normalize_value(@type, @field.value)
        }
        aria-invalid={@errores != [] && "true"}
        aria-describedby={describedby(@field.id, @ayuda, @errores)}
        {@rest}
      />
      <p :if={@ayuda} id={"#{@field.id}-ayuda"} class="campo__ayuda">{@ayuda}</p>
      <p :for={error <- @errores} id={"#{@field.id}-error"} class="campo__error">{error}</p>
    </div>
    """
  end

  defp describedby(id, ayuda, errores) do
    [ayuda && "#{id}-ayuda", errores != [] && "#{id}-error"]
    |> Enum.filter(& &1)
    |> case do
      [] -> nil
      ids -> Enum.join(ids, " ")
    end
  end

  @doc "Interpola los valores de un error de Ecto en su mensaje."
  @spec traducir_error({String.t(), keyword()}) :: String.t()
  def traducir_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {clave, valor}, acc ->
      String.replace(acc, "%{#{clave}}", fn _ -> to_string(valor) end)
    end)
  end
end
