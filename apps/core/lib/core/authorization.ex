defmodule Core.Authorization do
  @moduledoc false

  alias Core.Errors
  alias Core.Accounts.User

  @allowed_manager_actions ~w(create_task delete_task)a
  @allowed_driver_actions ~w(mark_task_as_done assign_task)a

  def can?(%User{type: :manager}, action) when action in @allowed_manager_actions, do: :ok
  def can?(%User{type: :driver}, action) when action in @allowed_driver_actions, do: :ok

  def can?(user, action),
    do: Errors.forbidden(reason: "User `#{user.id}` is not allowed to perform `#{action}`")
end
