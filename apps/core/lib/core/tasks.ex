defmodule Core.Tasks do
  @moduledoc false

  import Core.Errors

  alias Core.Repo
  alias Core.Tasks.Task
  alias Core.Tasks.Task

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def get_task(task_id) do
    Task
    |> Repo.get(task_id)
    |> not_found_if_nil(resource: :task, identifier: task_id)
  end

  def delete_task(%Task{} = task), do: Repo.delete(task)

  def mark_task_as_done(%Task{} = task) do
    task
    |> Task.mark_as_done()
    |> Repo.update()
  end

  def assign_task(%Task{} = task, user) do
    task
    |> Task.assign(user)
    |> Repo.update()
  end

  def list_tasks(lat, long) do
    Task
    |> Task.sort_by_distance(lat, long)
    |> Repo.all()
    |> wrap_ok()
  end

  defp wrap_ok(x), do: {:ok, x}
end
