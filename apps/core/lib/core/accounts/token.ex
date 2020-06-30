defmodule Core.Accounts.Token do
  @moduledoc false

  use Core.Schema
  alias Core.Accounts.User

  @required ~w(value)a
  schema "tokens" do
    field :value, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required)
    |> validate_required(@required)
  end

  def having_value(queryable, value), do: where(queryable, [q], q.value == ^value)
  def preload_user(queryable), do: preload(queryable, :user)
end
