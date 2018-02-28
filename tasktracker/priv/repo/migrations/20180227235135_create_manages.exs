defmodule Tasktracker.Repo.Migrations.CreateManages do
  use Ecto.Migration

  def change do
    create table(:manages) do
      add :manager_id, references(:users, on_delete: :delete_all), null: false
      add :member_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:manages, [:manager_id])
    create index(:manages, [:member_id])
  end
end
