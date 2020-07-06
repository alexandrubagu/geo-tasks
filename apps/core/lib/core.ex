defmodule Core do
  @moduledoc false

  alias Core.Accounts
  alias Core.Tasks
  alias Core.Authorization

  defdelegate authenticate(token), to: Accounts

  def create_task(attrs, user) do
    with :ok <- Authorization.can?(user, :create_task) do
      Tasks.create_task(attrs)
    end
  end

  def delete_task(task_id, user) do
    with :ok <- Authorization.can?(user, :delete_task),
         {:ok, task} <- Tasks.get_task(task_id) do
      Tasks.delete_task(task)
    end
  end

  def mark_task_as_done(task_id, user) do
    with :ok <- Authorization.can?(user, :mark_task_as_done),
         {:ok, task} <- Tasks.get_task(task_id) do
      Tasks.mark_task_as_done(task)
    end
  end

  def assign_task(task_id, user) do
    with :ok <- Authorization.can?(user, :assign_task),
         {:ok, task} <- Tasks.get_task(task_id) do
      Tasks.assign_task(task, user)
    end
  end

  def list_tasks(lat, long, user) do
    with :ok <- Authorization.can?(user, :list_tasks) do
      Tasks.list_tasks(lat, long)
    end
  end
end
