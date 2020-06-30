defmodule Core.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.Accounts.{User, Token}

  def token_factory do
    %Token{value: Faker.String.base64(100)}
  end

  def user_factory do
    %User{
      first_name: Faker.Name.first_name(),
      last_name: Faker.Name.last_name(),
      email: Faker.Internet.email(),
      type: sequence(:type, [:manager, :driver])
    }
  end
end
