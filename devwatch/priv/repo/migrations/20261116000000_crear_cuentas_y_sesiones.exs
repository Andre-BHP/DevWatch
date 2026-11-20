defmodule DevWatch.Repo.Migrations.CrearCuentasYSesiones do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:cuentas) do
      add :nombre, :string, size: 100, null: false
      add :correo, :citext, null: false
      add :huella_contrasena, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:cuentas, [:correo])

    create table(:sesiones) do
      add :cuenta_id, references(:cuentas, on_delete: :delete_all), null: false
      add :token, :binary, null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create index(:sesiones, [:cuenta_id])
    create unique_index(:sesiones, [:token])
  end
end
