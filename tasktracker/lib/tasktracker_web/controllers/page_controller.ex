defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, _params) do
    current_user = conn.assigns[:current_user]
    tasks = Tasktracker.Work.list_tasks()
    changeset = Tasktracker.Work.change_task(%Tasktracker.Work.Task{})

    tasks_designed = Enum.filter(tasks, fn (task) ->
      task.designer_id == current_user.id
    end)

    tasks_owned = Enum.filter(tasks, fn(task) ->
      task.owner_id == current_user.id
    end)

    render conn, "feed.html", tasks: tasks, tasks_designed: tasks_designed,
           tasks_owned: tasks_owned, changeset: changeset
  end
end
