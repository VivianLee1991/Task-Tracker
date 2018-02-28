defmodule Tasktracker.Work.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Work.Timeblock
  alias Tasktracker.Work.Task


  schema "timeblocks" do
    field :end, :utc_datetime
    field :start, :utc_datetime
    belongs_to :task, Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start, :end, :task_id])
    |> validate_required([:start, :end, :task_id])
  end
end
