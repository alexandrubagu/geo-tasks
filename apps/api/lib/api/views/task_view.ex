defmodule API.TaskView do
  @moduledoc false

  use API, :view

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, __MODULE__, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, __MODULE__, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      state: task.state,
      pickup: render_one(task.pickup, __MODULE__, "location.json", as: :location),
      delivery: render_one(task.delivery, __MODULE__, "location.json", as: :location),
      user_id: task.user_id,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end

  def render("location.json", %{location: location}) do
    %{
      lat: location.lat,
      long: location.long
    }
  end
end
