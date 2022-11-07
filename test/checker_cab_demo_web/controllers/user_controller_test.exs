defmodule CheckerCabDemoWeb.UserControllerTest do
  use CheckerCabDemoWeb.ConnCase

  alias CheckerCabDemo.Accounts.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user_params =
        IdleFactory.valid_params_for(User,
          skip_fields: [:id, :inserted_at, :updated_at]
        )

      conn = post(conn, Routes.user_path(conn, :create), user: user_params)
      response_body = %{"id" => id} = json_response(conn, 201)["data"]

      # option 1: pattern matching FTW (?)

      expected_age = user_params.age
      expected_name = user_params.name

      assert %{
               "id" => ^id,
               "age" => ^expected_age,
               "name" => ^expected_name
             } = response_body

      # option 2: a bunch of asserts

      assert response_body["age"] == user_params.age
      assert response_body["name"] == user_params.name
      # <insert every field>

      # option 3: CheckerCab
      # assert_values_for(
      #   expected: {user_params, :atom_keys},
      #   actual: {response_body, :string_keys},
      #   fields: fields_for(User),
      #   skip_fields: [:id, :inserted_at, :updated_at]
      # )

      # from_db = CheckerCabDemo.Repo.get(User, id)

      # assert_values_for(
      #   expected: {response_body, :string_keys},
      #   actual: from_db,
      #   fields: fields_for(User),
      #   opts: [convert_dates: true]
      # )
    end
  end
end
