defmodule Tasktracker.Repo.Migrations.CreateTimeblocks do
  use Ecto.Migration

  def change do
    create table(:timeblocks) do
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime, null: false
      add :task_id, references(:tasks, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:timeblocks, [:task_id])
  end
end
