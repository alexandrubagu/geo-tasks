defmodule Core.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.Accounts.{User, Token}
  alias Core.Tasks.{Location, Task}

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

  def location_factory do
    %Location{
      lat: "#{Enum.random(-90..90)}",
      long: "#{Enum.random(-180..180)}"
    }
  end

  def task_factory do
    %Task{
      state: sequence(:state, [:new, :assigned, :done]),
      pickup: build(:location),
      delivery: build(:location)
    }
  end
end
