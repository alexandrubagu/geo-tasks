defmodule API.TaskControllerTest do
  @moduledoc false

  use API.ConnCase, async: import(ExUnit.CaptureLog)
  import Core.Factory

  alias Core.Repo
  alias Core.Tasks.Task

  setup [:driver_fixture, :manager_fixture]

  test "returns an error when can not authenticate with provided token", %{conn: conn} do
    assert %{"error" => %{"message" => message}} =
             conn
             |> get(Routes.task_path(conn, :index), %{})
             |> json_response(401)

    assert message =~ "Unauthorized: Request is not allowed because of authentication problems."
  end

  describe "index" do
    @valid_attrs %{lat: "44.123", long: "44.0"}
    @invalid_attrs %{lat: "abc", long: nil}

    setup do
      task1 = insert(:task, pickup: build(:location, lat: -10, long: 10))
      task2 = insert(:task, pickup: build(:location, lat: 40, long: 40))

      {:ok, tasks: [task1, task2]}
    end

    test "returns a list of tasks using lat and long", %{conn: conn} = ctx do
      %{tasks: [task1, task2], manager: manager} = ctx

      assert %{"data" => tasks} =
               conn
               |> authenticate(manager)
               |> get(Routes.task_path(conn, :index), @valid_attrs)
               |> json_response(200)

      assert serialize(task1) in tasks
      assert serialize(task2) in tasks
    end

    test "returns an error when passing invalid params", %{conn: conn, manager: manager} do
      assert %{"error" => %{"info" => info, "type" => "unprocessable"}} =
               conn
               |> authenticate(manager)
               |> get(Routes.task_path(conn, :index), @invalid_attrs)
               |> json_response(422)

      assert %{"lat" => ["is invalid"], "long" => ["can't be blank"]} == info["errors"]
    end
  end

  describe "create" do
    @valid_attrs %{
      pickup: %{lat: "30.45", long: "150.55"},
      delivery: %{lat: "30.451", long: "150.551"}
    }

    @invalid_attrs %{state: nil, pickup: nil, delivery: nil}

    test "returns a created task", %{conn: conn, manager: manager} do
      assert %{"data" => %{"id" => id} = task} =
               conn
               |> authenticate(manager)
               |> post(Routes.task_path(conn, :create), @valid_attrs)
               |> json_response(201)

      assert Task
             |> Repo.get(id)
             |> serialize() == task
    end

    test "returns an error when passing invalid params", %{conn: conn, manager: manager} do
      assert %{"error" => %{"info" => info, "type" => "unprocessable"}} =
               conn
               |> authenticate(manager)
               |> post(Routes.task_path(conn, :create), @invalid_attrs)
               |> json_response(422)

      assert %{"delivery" => ["can't be blank"], "pickup" => ["can't be blank"]} = info["errors"]
    end

    test "returns an error when logged user is a driver", %{conn: conn, driver: driver} do
      assert capture_log(fn ->
               conn
               |> authenticate(driver)
               |> post(Routes.task_path(conn, :create), @valid_attrs)
               |> json_response(403)
             end) =~ "not allowed to perform `create_task`"
    end
  end

  describe "delete" do
    test "returns deleted task", %{conn: conn, manager: manager} do
      task = insert(:task, user: manager)

      assert %{"data" => serialized_task} =
               conn
               |> authenticate(manager)
               |> delete(Routes.task_path(conn, :delete, task))
               |> json_response(200)

      assert serialize(task) == serialized_task
      refute Repo.get(Task, task.id)
    end

    test "returns an error when logged user is a driver", %{conn: conn, driver: driver} do
      task = insert(:task, user: driver)

      assert capture_log(fn ->
               conn
               |> authenticate(driver)
               |> delete(Routes.task_path(conn, :delete, task))
               |> json_response(403)
             end) =~ "not allowed to perform `delete_task`"
    end
  end

  describe "mark_as_done" do
    test "marks a task as done", %{conn: conn, driver: driver} do
      task = insert(:task, user: driver)

      assert %{"data" => %{"state" => "done"} = serialized_task} =
               conn
               |> authenticate(driver)
               |> post(Routes.task_task_path(conn, :mark_as_done, task))
               |> json_response(200)

      assert Task
             |> Repo.get(task.id)
             |> serialize == serialized_task
    end

    test "returns an error when logged user is a driver", %{conn: conn, manager: manager} do
      task = insert(:task, user: manager)

      assert capture_log(fn ->
               conn
               |> authenticate(manager)
               |> post(Routes.task_task_path(conn, :mark_as_done, task))
               |> json_response(403)
             end) =~ "not allowed to perform `mark_task_as_done`"
    end
  end

  describe "assign" do
    test "assigns a task to a logged user", %{conn: conn, driver: %{id: user_id} = driver} do
      task = insert(:task, user: driver)

      assert %{"data" => %{"user_id" => ^user_id} = serialized_task} =
               conn
               |> authenticate(driver)
               |> post(Routes.task_task_path(conn, :assign, task))
               |> json_response(200)

      assert Task
             |> Repo.get(task.id)
             |> serialize == serialized_task
    end

    test "returns an error when logged user is a driver", %{conn: conn, manager: manager} do
      task = insert(:task, user: manager)

      assert capture_log(fn ->
               conn
               |> authenticate(manager)
               |> post(Routes.task_task_path(conn, :assign, task))
               |> json_response(403)
             end) =~ "not allowed to perform `assign_task`"
    end
  end

  defp serialize(task) do
    %{
      "id" => task.id,
      "state" => to_string(task.state),
      "pickup" => %{"lat" => task.pickup.lat, "long" => task.pickup.long},
      "delivery" => %{"lat" => task.delivery.lat, "long" => task.delivery.long},
      "user_id" => task.user_id,
      "inserted_at" => NaiveDateTime.to_iso8601(task.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(task.updated_at)
    }
  end

  defp driver_fixture(_), do: {:ok, driver: insert(:user, type: :driver)}
  defp manager_fixture(_), do: {:ok, manager: insert(:user, type: :manager)}

  def authenticate(conn, user) do
    token = insert(:token, user: user)
    authorize_conn(conn, token.value)
  end
end
