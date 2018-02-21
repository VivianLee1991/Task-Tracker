defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, _params) do
    tasks = Tasktracker.Work.list_tasks()
    changeset = Tasktracker.Work.change_task(%Tasktracker.Work.Task{})
    render conn, "feed.html", tasks: tasks, changeset: changeset
  end
end
