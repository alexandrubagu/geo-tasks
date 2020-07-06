defmodule API.TaskController do
  @moduledoc false

  use API, :controller

  action_fallback API.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.logged_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, params, logged_user) do
    with {:ok, location} <- Core.validate_location(params),
         {:ok, tasks} <- Core.list_tasks(location.lat, location.long, logged_user) do
      render(conn, "index.json", tasks: tasks)
    end
  end

  def create(conn, params, logged_user) do
    with {:ok, task} <- Core.create_task(params, logged_user) do
      conn
      |> put_status(:created)
      |> render("show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}, logged_user) do
    with {:ok, task} <- Core.delete_task(id, logged_user) do
      render(conn, "show.json", task: task)
    end
  end

  def mark_as_done(conn, %{"task_id" => id}, logged_user) do
    with {:ok, task} <- Core.mark_task_as_done(id, logged_user) do
      render(conn, "show.json", task: task)
    end
  end

  def assign(conn, %{"task_id" => id}, logged_user) do
    with {:ok, task} <- Core.assign_task(id, logged_user) do
      render(conn, "show.json", task: task)
    end
  end
end
