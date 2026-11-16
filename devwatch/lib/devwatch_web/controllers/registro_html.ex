defmodule DevWatchWeb.RegistroHTML do
  use DevWatchWeb, :html

  def new(assigns) do
    ~H"""
    <Layouts.app flash={@flash} estrecho>
      <h1>Crear cuenta</h1>
      <p class="tenue">Los tres datos son obligatorios.</p>
      <.form for={@form} action={~p"/registro"} id="formulario-registro">
        <.campo field={@form[:nombre]} label="Nombre" autocomplete="name" maxlength="100" required />
        <.campo
          field={@form[:correo]}
          label="Correo"
          type="email"
          autocomplete="email"
          maxlength="160"
          required
        />
        <.campo
          field={@form[:contrasena]}
          label="Contraseña"
          type="password"
          ayuda="Entre 12 y 128 caracteres."
          autocomplete="new-password"
          required
        />
        <button type="submit" class="boton boton--primario">Crear cuenta</button>
      </.form>
      <p class="tenue separado">
        ¿Ya tienes cuenta? <a href={~p"/iniciar-sesion"}>Inicia sesión</a>
      </p>
    </Layouts.app>
    """
  end
end
