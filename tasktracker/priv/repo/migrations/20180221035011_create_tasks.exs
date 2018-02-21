defmodule Tasktracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :text, null: false
      add :description, :text, null: false
      add :time_spent, :integer, default: 0, null: false
      add :is_complete, :boolean, default: false, null: false
      add :designer_id, references(:users, on_delete: :delete_all), null: false
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:designer_id])
    create index(:tasks, [:owner_id])
  end
end
