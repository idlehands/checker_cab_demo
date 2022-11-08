defmodule CheckerCabDemo.Accounts.UserTest do
  use CheckerCabDemo.DataCase
  alias CheckerCabDemo.Accounts.User

  @schema_fields_and_types [
    {:age, :integer},
    {:id, Ecto.UUID},
    {:inserted_at, :utc_datetime_usec},
    {:name, :string},
    {:updated_at, :utc_datetime_usec}
  ]

  describe "fields and types" do
    validate_schema_fields_and_types(User, @schema_fields_and_types)
  end
end
