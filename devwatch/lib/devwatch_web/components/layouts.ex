defmodule DevWatchWeb.Layouts do
  @moduledoc """
  Plantilla raíz y estructura de las páginas.
  """
  use DevWatchWeb, :html

  embed_templates "layouts/*"

  @doc "Estructura de una página: mensajes y contenido."
  attr :flash, :map, required: true
  attr :estrecho, :boolean, default: false
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <main id="contenido" class={["contenido", @estrecho && "contenido--estrecho"]}>
      <.mensajes flash={@flash} />
      {render_slot(@inner_block)}
    </main>
    """
  end
end
