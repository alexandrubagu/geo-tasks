defmodule CoreTest do
  @moduledoc false

  use Core.DataCase, async: true

  import Core.Factory

  alias Ecto.Changeset
  alias Core.Repo
  alias Core.Errors.{ForbiddenError, UnauthorizedError}
  alias Core.Tasks.Task

  describe "create_task/2" do
    @valid_attrs %{
      pickup: %{lat: "30.45", long: "150.55"},
      delivery: %{lat: "30.451", long: "150.551"}
    }

    @invalid_attrs %{state: nil, pickup: nil, delivery: nil}

    setup do
      manager = insert(:user, type: :manager)
      token = insert(:token, user_id: manager.id)

      {:ok, token: token, manager: manager}
    end

    test "returns an error when token is not found" do
      assert {:error, %UnauthorizedError{}} = Core.create_task("unexisting_token", @valid_attrs)
    end

    test "returns an error when user is not allowed to perform a task creation" do
      driver = insert(:user, type: :driver)
      token = insert(:token, user: driver)

      assert {:error, %ForbiddenError{reason: reason}} =
               Core.create_task(token.value, @valid_attrs)

      assert reason =~ "is not allowed to perform `create_task`"
    end

    test "returns a task when passing valid data", %{token: token} do
      assert {:ok, %Task{}} = Core.create_task(token.value, @valid_attrs)
    end

    test "returns errors when passing invalid data", %{token: token} do
      assert {:error, %Changeset{valid?: false}} = Core.create_task(token.value, @invalid_attrs)
    end
  end

  describe "delete_task/2" do
    setup do
      manager = insert(:user, type: :manager)
      token = insert(:token, user_id: manager.id)
      task = insert(:task, user: manager)

      {:ok, token: token, task: task, manager: manager}
    end

    test "returns an error when token is not found", %{task: task} do
      assert {:error, %UnauthorizedError{}} = Core.delete_task("unexisting_token", task.id)
    end

    test "returns an error when user is not allowed to perform a task deletion", %{task: task} do
      driver = insert(:user, type: :driver)
      token = insert(:token, user: driver)

      assert {:error, %ForbiddenError{reason: reason}} = Core.delete_task(token.value, task.id)
      assert reason =~ "is not allowed to perform `delete_task`"
    end

    test "deletes a task", %{token: token, task: task} do
      assert {:ok, %Task{}} = Core.delete_task(token.value, task.id)
    end
  end

  describe "mark_task_as_done/2" do
    setup do
      driver = insert(:user, type: :driver)
      token = insert(:token, user_id: driver.id)
      task = insert(:task, user: driver)

      {:ok, token: token, task: task, driver: driver}
    end

    test "returns an error when token is not found", %{task: task} do
      assert {:error, %UnauthorizedError{}} = Core.mark_task_as_done("unexisting_token", task.id)
    end

    test "returns an error when user is not allowed to update state of a task", %{task: task} do
      manager = insert(:user, type: :manager)
      token = insert(:token, user: manager)

      assert {:error, %ForbiddenError{reason: reason}} =
               Core.mark_task_as_done(token.value, task.id)

      assert reason =~ "is not allowed to perform `mark_task_as_done`"
    end

    test "mark a task as done", %{token: token, task: task} do
      assert {:ok, %Task{}} = Core.mark_task_as_done(token.value, task.id)
    end
  end

  describe "assign_task/2" do
    setup do
      driver = insert(:user, type: :driver)
      token = insert(:token, user_id: driver.id)
      task = insert(:task, user: driver)

      {:ok, token: token, task: task, driver: driver}
    end

    test "returns an error when token is not found", %{task: task} do
      assert {:error, %UnauthorizedError{}} = Core.assign_task("unexisting_token", task.id)
    end

    test "returns an error when user is not allowed to update state of a task", %{task: task} do
      manager = insert(:user, type: :manager)
      token = insert(:token, user: manager)

      assert {:error, %ForbiddenError{reason: reason}} = Core.assign_task(token.value, task.id)
      assert reason =~ "is not allowed to perform `assign_task`"
    end

    test "mark a task as done", %{token: token, task: task} do
      assert {:ok, %Task{}} = Core.assign_task(token.value, task.id)
    end
  end
end
