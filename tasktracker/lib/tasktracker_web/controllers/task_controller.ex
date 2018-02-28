defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Work
  alias Tasktracker.Work.Task
  alias Tasktracker.Account

  def index(conn, _params) do
    tasks = Work.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end


  def new(conn, _params) do
    changeset = Work.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"task" => task_params}) do
    current_user = conn.assigns[:current_user]  # designer of the task
    owner_name = task_params["owner_name"]
    owner = Account.get_user_by_name(owner_name)

    if !owner do
      conn
      |> put_flash(:error, "Unregistered owner name!")
      |> redirect(to: page_path(conn, :feed))
    else
      owner_id = owner.id
      manage = Work.is_my_member(current_user.id, owner_id)

      if manage == [] do
        conn
        |> put_flash(:error, "Can't assign task to non-member!")
        |> redirect(to: page_path(conn, :feed))
      else
        task_params = Map.delete(task_params, :owner_name)
        task_params = Map.merge(task_params, %{"owner_id" => owner_id})
        task_params = Map.merge(task_params, %{"designer_id" => current_user.id})

        case Work.create_task(task_params) do
          {:ok, task} ->
            conn
            |> put_flash(:info, "Task created successfully.")
            |> redirect(to: task_path(conn, :show, task))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end
    end
  end


  def show(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    changeset = Work.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def editbyowner(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    changeset = Work.change_task(task)
    timeblocks =
      Work.list_timeblocks()
      |> Enum.filter(fn(tb) ->
          tb.task_id == task.id end)
      |> Enum.reverse
    render(conn, "editbyowner.html", task: task, timeblocks: timeblocks, changeset: changeset)
  end


  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Work.get_task!(id)
    owner_name = task_params["owner_name"]
    owner = Account.get_user_by_name(owner_name)

    if !owner do
      conn
      |> put_flash(:error, "Unregistered owner name!")
      |> redirect(to: task_path(conn, :edit, task))
    else
      current_user = conn.assigns[:current_user]
      owner_id = owner.id
      manage = Work.is_my_member(current_user.id, owner_id)

      if manage == [] do
        conn
        |> put_flash(:error, "Can't assign task to non-member!")
        |> redirect(to: task_path(conn, :edit, task))
      else
        task_params = Map.delete(task_params, :owner_name)
        task_params = Map.merge(task_params, %{"owner_id" => owner_id})

        case Work.update_task(task, task_params) do
          {:ok, task} ->
            conn
            |> put_flash(:info, "Task updated successfully.")
            |> redirect(to: page_path(conn, :feed))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", task: task, changeset: changeset)
        end
      end
    end
  end


  def delete(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    {:ok, _task} = Work.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: page_path(conn, :feed))
  end

end
