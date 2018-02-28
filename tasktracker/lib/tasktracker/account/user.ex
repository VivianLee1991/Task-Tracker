defmodule Tasktracker.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Account.User
  alias Tasktracker.Work.Manage


  schema "users" do
    field :email, :string
    field :name, :string

    has_many :manager_manages, Manage, foreign_key: :manager_id
    has_many :member_manages, Manage, foreign_key: :member_id
    has_many :managers, through: [:member_manages, :manager]
    has_many :members, through: [:manager_manages, :member]

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name])
    |> validate_required([:email, :name])
  end
end
