defmodule Core.AccountsTest do
  @moduledoc false

  use Core.DataCase, async: true

  import Core.Factory

  alias Core.Repo
  alias Core.Errors.UnauthorizedError
  alias Core.Accounts
  alias Core.Accounts.{User, Token}

  describe "create_user/1" do
    @valid_attrs %{
      first_name: "Alex",
      last_name: "Alex",
      email: "alexandrubagu87@gmail.com",
      type: "manager"
    }

    @invalid_attrs %{
      first_name: nil,
      last_name: nil,
      email: nil,
      type: nil
    }

    test "returns a user when passing valid data" do
      assert {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == @valid_attrs.first_name
      assert user.last_name == @valid_attrs.last_name
      assert user.email == @valid_attrs.email
      assert user.type == :manager
      assert user.id
    end

    test "returns errors when passing invalid data" do
      assert {:error, changeset} = Accounts.create_user(@invalid_attrs)
      assert "can't be blank" in errors_on(changeset)[:email]
      assert "can't be blank" in errors_on(changeset)[:type]
    end

    test "returns an error when user type is not driver or manager" do
      invalid_attrs = %{@valid_attrs | type: "unknown type"}
      assert {:error, changeset} = Accounts.create_user(invalid_attrs)
      assert "is invalid" in errors_on(changeset)[:type]
    end
  end

  describe "delete_user/1" do
    setup _, do: {:ok, user: insert(:user)}

    test "deletes a user", %{user: user} do
      assert {:ok, _deleted_user} = Accounts.delete_user(user)
      refute Repo.get(User, user.id)
    end
  end

  describe "create_token/2" do
    @valid_attrs %{value: "some generated random token"}
    @invalid_attrs %{value: nil}

    setup _, do: {:ok, user: insert(:user)}

    test "creates a token for a specified user", %{user: user} do
      assert {:ok, token} = Accounts.create_token(user, @valid_attrs)
      assert token.value == @valid_attrs.value
    end

    test "returns errors when passing invalid data", %{user: user} do
      assert {:error, changeset} = Accounts.create_token(user, @invalid_attrs)
      assert "can't be blank" in errors_on(changeset)[:value]
    end
  end

  describe "delete_token/1" do
    setup do
      user = insert(:user)
      token = insert(:token, user_id: user.id)

      {:ok, token: token}
    end

    test "deletes a token", %{token: token} do
      assert {:ok, _deleted_token} = Accounts.delete_token(token)
      refute Repo.get(Token, token.id)
    end
  end

  describe "authenticate/1" do
    setup do
      user = insert(:user)
      token = insert(:token, user: user)

      {:ok, user: user, token: token}
    end

    test "authenticates a user using provided token", %{user: user, token: token} do
      assert {:ok, ^user} = Accounts.authenticate(token.value)
    end

    test "returns an unauthorized error if token doesn't exists" do
      assert {:error, %UnauthorizedError{}} = Accounts.authenticate("unexisting_token")
    end
  end
end
