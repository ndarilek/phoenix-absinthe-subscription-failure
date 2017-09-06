defmodule App.Repo.Migrations.CreatePasswordResetToken do
  use Ecto.Migration

  def change do
    create table(:password_reset_tokens) do
      add :value, :string, null: false, unique: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps(updated_at: false)
    end
    create index(:password_reset_tokens, [:user_id])

  end
end
