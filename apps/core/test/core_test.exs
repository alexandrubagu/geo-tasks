defmodule CoreTest do
  @moduledoc false

  use Core.DataCase, async: true

  import Core.Factory

  alias Ecto.Changeset
  alias Core.Errors.Forbidden
  alias Core.Tasks.Task

  describe "create_task/2" do
    @valid_attrs %{
      pickup: %{lat: "30.45", long: "150.55"},
      delivery: %{lat: "30.451", long: "150.551"}
    }

    @invalid_attrs %{state: nil, pickup: nil, delivery: nil}

    setup do
      manager = insert(:user, type: :manager)
      insert(:token, user_id: manager.id)

      {:ok, logged_user: manager}
    end

    test "returns an error when user is not allowed to perform a task creation" do
      driver = insert(:user, type: :driver)
      insert(:token, user_id: driver.id)

      assert {:error, %Forbidden{reason: reason}} = Core.create_task(@valid_attrs, driver)
      assert reason =~ "is not allowed to perform `create_task`"
    end

    test "returns a task when passing valid data", %{logged_user: manager} do
      assert {:ok, %Task{}} = Core.create_task(@valid_attrs, manager)
    end

    test "returns errors when passing invalid data", %{logged_user: manager} do
      assert {:error, %Changeset{valid?: false}} = Core.create_task(@invalid_attrs, manager)
    end
  end

  describe "delete_task/2" do
    setup do
      manager = insert(:user, type: :manager)
      insert(:token, user_id: manager.id)
      task = insert(:task, user: manager)

      {:ok, logged_user: manager, task: task}
    end

    test "returns an error when logged user is not allowed to perform a task deletion", %{
      task: task
    } do
      driver = insert(:user, type: :driver)
      insert(:token, user: driver)

      assert {:error, %Forbidden{reason: reason}} = Core.delete_task(task.id, driver)
      assert reason =~ "is not allowed to perform `delete_task`"
    end

    test "deletes a task", %{logged_user: manager, task: task} do
      assert {:ok, %Task{}} = Core.delete_task(task.id, manager)
    end
  end

  describe "mark_task_as_done/2" do
    setup do
      driver = insert(:user, type: :driver)
      insert(:token, user_id: driver.id)
      task = insert(:task, user: driver)

      {:ok, task: task, logged_user: driver}
    end

    test "returns an error when user is not allowed to update state of a task", %{task: task} do
      manager = insert(:user, type: :manager)
      insert(:token, user: manager)

      assert {:error, %Forbidden{reason: reason}} = Core.mark_task_as_done(task.id, manager)
      assert reason =~ "is not allowed to perform `mark_task_as_done`"
    end

    test "mark a task as done", %{logged_user: driver, task: task} do
      assert {:ok, %Task{}} = Core.mark_task_as_done(task.id, driver)
    end
  end

  describe "assign_task/2" do
    setup do
      driver = insert(:user, type: :driver)
      insert(:token, user_id: driver.id)
      task = insert(:task, user: driver)

      {:ok, task: task, logged_user: driver}
    end

    test "returns an error when user is not allowed to update state of a task", %{task: task} do
      manager = insert(:user, type: :manager)
      insert(:token, user: manager)

      assert {:error, %Forbidden{reason: reason}} = Core.assign_task(task.id, manager)
      assert reason =~ "is not allowed to perform `assign_task`"
    end

    test "mark a task as done", %{logged_user: driver, task: task} do
      assert {:ok, %Task{}} = Core.assign_task(task.id, driver)
    end
  end
end
