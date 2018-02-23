defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Account
  alias Tasktracker.Account.User

  def index(conn, _params) do
    users = Account.list_users()
    current_user = conn.assigns[:current_user]
    render(conn, "index.html", users: users, current_user: current_user)
  end

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    current_user = conn.assigns[:current_user]
    render(conn, "show.html", user: user, current_user: current_user)
  end

  def edit(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    changeset = Account.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    case Account.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    {:ok, _user} = Account.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
