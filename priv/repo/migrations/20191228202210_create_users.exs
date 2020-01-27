defmodule TestCasePhoenix.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string, null: false
      add :password, :string, null: false
      add :is_admin, :boolean, default: false, null: false
      add :is_banned, :boolean, default: false, null: false
      add :is_muted, :boolean, default: false, null: false

      timestamps()
    end

  end
end
