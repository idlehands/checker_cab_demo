defmodule CheckerCabDemo.AccountsTest do
  use CheckerCabDemo.DataCase

  alias CheckerCabDemo.Accounts
  alias CheckerCabDemo.Accounts.User

  describe "users" do
    @invalid_attrs %{age: nil, name: nil}

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{age: 42, name: "some name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.age == 42
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end

  describe "create_user/1" do
    test "success: it creates and returns a user" do
      valid_attrs =
        CheckerCabDemo.IdleFactory.valid_params_for(User,
          skip_fields: [:id, :inserted_at, :updated_at]
        )

      assert {:ok, %User{} = returned_user} = Accounts.create_user(valid_attrs)

      # test return_value
      assert_values_for(
        expected: valid_attrs,
        actual: returned_user,
        fields: fields_for(User),
        skip_fields: [:id, :inserted_at, :updated_at]
      )

      # test side effect
      from_db = CheckerCabDemo.Repo.get(User, returned_user.id)

      assert returned_user == from_db
    end
  end
end
