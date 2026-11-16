defmodule DevWatchWeb.PaginaHTML do
  use DevWatchWeb, :html

  def inicio(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <section class="portada">
        <h1>Monitoreo explicable para aplicaciones Elixir</h1>
        <p class="lead">
          DevWatch recibe el resumen de cada operación que observas, la clasifica con un catálogo
          de reglas visible y reúne los problemas que se repiten en incidencias con prioridad
          calculada.
        </p>
        <div :if={!@current_scope} class="acciones">
          <a class="boton boton--primario" href={~p"/registro"}>Crear cuenta</a>
          <a class="boton" href={~p"/iniciar-sesion"}>Iniciar sesión</a>
        </div>
      </section>
    </Layouts.app>
    """
  end
end
