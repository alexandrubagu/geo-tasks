defmodule Core.TasksTest do
  @moduledoc false

  use Core.DataCase, async: true

  import Core.Factory

  alias Core.Repo
  alias Core.Errors.NotFound
  alias Core.Tasks
  alias Core.Tasks.{Task, Location}

  describe "create_task/1" do
    @valid_attrs %{
      pickup: %{lat: "30.45", long: "150.55"},
      delivery: %{lat: "30.451", long: "150.551"}
    }

    @invalid_attrs %{
      state: nil,
      pickup: nil,
      delivery: nil
    }

    test "returns a user when passing valid data" do
      assert {:ok, task} = Tasks.create_task(@valid_attrs)
      assert task.pickup == struct(Location, @valid_attrs.pickup)
      assert task.delivery == struct(Location, @valid_attrs.delivery)
      assert task.state == :new
      assert task.id
    end

    test "returns errors when passing invalid data" do
      assert {:error, changeset} = Tasks.create_task(@invalid_attrs)
      assert "can't be blank" in errors_on(changeset)[:pickup]
      assert "can't be blank" in errors_on(changeset)[:delivery]
    end

    test "returns an error when state is invalid" do
      invalid_attrs = Map.put(@valid_attrs, :state, "unknown-state")
      assert {:error, changeset} = Tasks.create_task(invalid_attrs)
      assert "is invalid" in errors_on(changeset)[:state]
    end
  end

  describe "get_task/1" do
    @unexisting_task_id Ecto.UUID.generate()

    setup _, do: {:ok, task: insert(:task)}

    test "returns a task by id", %{task: task} do
      assert {:ok, ^task} = Tasks.get_task(task.id)
    end

    test "returns an error when task doesn't exists" do
      assert {:error, %NotFound{resource: :task, identifier: @unexisting_task_id}} =
               Tasks.get_task(@unexisting_task_id)
    end
  end

  describe "delete_task/1" do
    @unexisting_task_id Ecto.UUID.generate()

    setup _, do: {:ok, task: insert(:task)}

    test "returns a task by id", %{task: task} do
      assert {:ok, _deleted_task} = Tasks.delete_task(task)
      refute Repo.get(Task, task.id)
    end
  end

  describe "mark_as_done/1" do
    setup _, do: {:ok, task: insert(:task, state: :assigned)}

    test "marks a task as done", %{task: task} do
      assert {:ok, %Task{} = updated_task} = Tasks.mark_task_as_done(task)
      assert updated_task.id == task.id
      assert updated_task.pickup == task.pickup
      assert updated_task.delivery == task.delivery
      assert updated_task.state == :done
    end
  end

  describe "assign_task/2" do
    setup do
      {:ok, task: insert(:task), user: insert(:user)}
    end

    test "assigns a task to a specific user", %{task: task, user: user} do
      assert {:ok, %Task{} = updated_task} = Tasks.assign_task(task, user)
      assert updated_task.id == task.id
      assert updated_task.pickup == task.pickup
      assert updated_task.delivery == task.delivery
      assert updated_task.state == :assigned
      assert updated_task.user_id == user.id
    end
  end
end
