defmodule DevWatch.Accounts.Cuenta do
  @moduledoc """
  Cuenta de usuario: nombre, correo y huella de la contraseña (V10, módulo de cuentas).

  La contraseña nunca se guarda: solo su huella Argon2id con sal aleatoria.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @longitud_minima 12
  @longitud_maxima 128

  schema "cuentas" do
    field :nombre, :string
    field :correo, :string
    field :contrasena, :string, virtual: true, redact: true
    field :huella_contrasena, :string, redact: true

    timestamps(type: :utc_datetime_usec)
  end

  @doc "Longitudes admitidas de la contraseña (V10: entre 12 y 128 caracteres)."
  def longitud_contrasena, do: {@longitud_minima, @longitud_maxima}

  @doc """
  Changeset de registro. Con `hash: false` solo valida (para mostrar el formulario).
  """
  def registro_changeset(cuenta, attrs, opts \\ []) do
    cuenta
    |> cast(attrs, [:nombre, :correo, :contrasena], empty_values: [])
    |> validar_nombre()
    |> validar_correo()
    |> validar_contrasena(opts)
  end

  defp validar_nombre(changeset) do
    changeset
    |> update_change(:nombre, &String.trim/1)
    |> validate_required([:nombre], message: "El nombre es obligatorio")
    |> validate_length(:nombre, max: 100, message: "El nombre admite hasta %{count} caracteres")
  end

  defp validar_correo(changeset) do
    changeset
    |> update_change(:correo, &String.trim/1)
    |> validate_required([:correo], message: "El correo es obligatorio")
    |> validate_format(:correo, ~r/^[^@,;\s]+@[^@,;\s]+\.[^@,;\s]+$/,
      message: "El correo no tiene un formato válido"
    )
    |> validate_length(:correo, max: 160, message: "El correo admite hasta %{count} caracteres")
    |> unsafe_validate_unique(:correo, DevWatch.Repo,
      message: "El correo ya pertenece a otra cuenta"
    )
    |> unique_constraint(:correo, message: "El correo ya pertenece a otra cuenta")
  end

  defp validar_contrasena(changeset, opts) do
    changeset
    |> validate_required([:contrasena], message: "La contraseña es obligatoria", trim: false)
    |> validate_length(:contrasena,
      min: @longitud_minima,
      max: @longitud_maxima,
      count: :codepoints,
      message:
        "La contraseña debe tener entre #{@longitud_minima} y #{@longitud_maxima} caracteres"
    )
    |> calcular_huella(opts)
  end

  defp calcular_huella(changeset, opts) do
    contrasena = get_change(changeset, :contrasena)

    if Keyword.get(opts, :hash, true) && contrasena && changeset.valid? do
      changeset
      |> put_change(:huella_contrasena, Argon2.hash_pwd_salt(contrasena))
      |> delete_change(:contrasena)
    else
      changeset
    end
  end

  @doc """
  Comprueba una contraseña contra la huella guardada. Sin cuenta, ejecuta una comprobación
  falsa para que el tiempo de respuesta no revele si el correo existe.
  """
  @spec contrasena_valida?(t() | nil, String.t()) :: boolean()
  def contrasena_valida?(%__MODULE__{huella_contrasena: huella}, contrasena)
      when is_binary(huella) and byte_size(contrasena) > 0 do
    Argon2.verify_pass(contrasena, huella)
  end

  def contrasena_valida?(_, _) do
    Argon2.no_user_verify()
    false
  end
end
