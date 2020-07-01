defmodule Core do
  @moduledoc false

  alias Core.Accounts
  alias Core.Tasks
  alias Core.Authorization

  def create_task(token_value, attrs) do
    with {:ok, user} <- Accounts.authenticate(token_value),
         :ok <- Authorization.can?(user, :create_task) do
      Tasks.create_task(attrs)
    end
  end

  def delete_task(token_value, task_id) do
    with {:ok, user} <- Accounts.authenticate(token_value),
         :ok <- Authorization.can?(user, :delete_task),
         {:ok, task} <- Tasks.get_task(task_id) do
      Tasks.delete_task(task)
    end
  end

  def mark_as_done(token_value, task_id) do
    with {:ok, user} <- Accounts.authenticate(token_value),
         :ok <- Authorization.can?(user, :mark_as_done),
         {:ok, task} <- Tasks.get_task(task_id) do
      Tasks.mark_task_as_done(task)
    end
  end

  def assign_task(token_value, task_id) do
    with {:ok, user} <- Accounts.authenticate(token_value),
         :ok <- Authorization.can?(user, :assign_task),
         {:ok, task} <- Tasks.get_task(task_id) do
      Tasks.assign_task(task, user)
    end
  end
end
