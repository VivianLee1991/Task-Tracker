defmodule Tasktracker.Work.Manage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Work.Manage
  alias Tasktracker.Account.User


  schema "manages" do
    belongs_to :manager, User
    belongs_to :member, User

    timestamps()
  end

  @doc false
  def changeset(%Manage{} = manage, attrs) do
    manage
    |> cast(attrs, [:manager_id, :member_id])
    |> validate_required([:manager_id, :member_id])
  end
end
