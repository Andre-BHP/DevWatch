defmodule DevWatchWeb.SesionHTML do
  use DevWatchWeb, :html

  def new(assigns) do
    ~H"""
    <Layouts.app flash={@flash} estrecho>
      <h1>Iniciar sesión</h1>
      <.form for={@form} action={~p"/iniciar-sesion"} id="formulario-sesion">
        <.campo
          field={@form[:correo]}
          label="Correo"
          type="email"
          autocomplete="username"
          required
        />
        <.campo
          field={@form[:contrasena]}
          label="Contraseña"
          type="password"
          autocomplete="current-password"
          required
        />
        <button type="submit" class="boton boton--primario">Iniciar sesión</button>
      </.form>
      <p class="tenue separado">
        ¿No tienes cuenta? <a href={~p"/registro"}>Crea una</a>
      </p>
    </Layouts.app>
    """
  end
end
