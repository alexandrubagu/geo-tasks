defmodule Core.Accounts.User do
  @moduledoc false

  use Core.Schema

  alias Core.Accounts.Token
  alias Core.Tasks.Task

  defenum Type, manager: 0, driver: 1

  @required ~w(email type)a
  @optional ~w(first_name last_name)a
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :type, Type

    has_one :token, Token
    has_many :tasks, Task

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
