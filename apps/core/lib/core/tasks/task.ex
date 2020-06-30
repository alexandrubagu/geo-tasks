defmodule Core.Tasks.Task do
  @moduledoc false

  use Core.Schema

  alias Core.Tasks.Location

  defenum Type, new: 0, assigned: 1, done: 2

  @required ~w(state)a
  schema "tasks" do
    field :state, Type, default: :new
    embeds_one :pickup, Location
    embeds_one :delivery, Location

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @required)
    |> cast_embed(:pickup, required: true)
    |> cast_embed(:delivery, required: true)
  end
end
