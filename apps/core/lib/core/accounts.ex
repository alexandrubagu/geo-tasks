defmodule Core.Accounts do
  @moduledoc false

  import Core.Errors

  alias Core.Repo
  alias Core.Accounts.User
  alias Core.Accounts.Token

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def delete_user(%User{} = user), do: Repo.delete(user)

  def create_token(%User{} = user, attrs) do
    user
    |> Ecto.build_assoc(:token)
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  def delete_token(%Token{} = token), do: Repo.delete(token)

  def authenticate(token) do
    result =
      Token
      |> Token.having_value(token)
      |> Token.preload_user()
      |> Repo.one()

    case result do
      %Token{} = token -> {:ok, token.user}
      _ -> unauthorized()
    end
  end
end
