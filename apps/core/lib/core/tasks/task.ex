defmodule Core.Tasks.Task do
  @moduledoc false

  use Core.Schema

  alias Core.Accounts.User
  alias Core.Tasks.Location

  defenum State, new: 0, assigned: 1, done: 2

  @required ~w(state)a
  schema "tasks" do
    field :state, State, default: :new
    embeds_one :pickup, Location
    embeds_one :delivery, Location

    belongs_to :user, User

    timestamps()
  end

  def mark_as_done(task), do: change(task, %{state: :done})
  def assign(task, user), do: change(task, %{user_id: user.id, state: :assigned})

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @required)
    |> cast_embed(:pickup, required: true)
    |> cast_embed(:delivery, required: true)
  end
end
