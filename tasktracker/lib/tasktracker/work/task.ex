defmodule Tasktracker.Work.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Work.Task


  schema "tasks" do
    field :description, :string
    field :is_complete, :boolean, default: false
    field :time_spent, :integer, default: 0
    field :title, :string
    belongs_to :designer, Tasktracker.Account.User
    belongs_to :owner, Tasktracker.Account.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :time_spent, :is_complete, :designer_id])
    |> validate_required([:title, :description, :time_spent, :is_complete, :designer_id])
  end
end
