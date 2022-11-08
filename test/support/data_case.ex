defmodule CheckerCabDemo.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use CheckerCabDemo.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias CheckerCabDemo.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import CheckerCabDemo.DataCase
      import CheckerCab
      require CheckerCabDemo.IdleFactory
    end
  end

  setup tags do
    CheckerCabDemo.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(CheckerCabDemo.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  defmacro validate_schema_fields_and_types(schema, expected_schemas_and_types) do
    quote do
      test "#{unquote(schema)}: it has the correct fields and types" do
        schema = unquote(schema)
        expected_schemas_and_types = unquote(expected_schemas_and_types)

        actual_fields_with_types =
          for field <- schema.__schema__(:fields) do
            type = field_type(schema, field)

            {field, type}
          end

        assert Enum.sort(actual_fields_with_types) ==
                 Enum.sort(expected_schemas_and_types)
      end
    end
  end

  def field_type(module, field) do
    case module.__schema__(:type, field) do
      {:parameterized, Ecto.Embedded, %Ecto.Embedded{related: embedded_type}} ->
        {:embedded_schema, embedded_type}

      {:parameterized, Ecto.Enum, enum_data} ->
        {Ecto.Enum, Keyword.keys(enum_data.mappings)}

      anything_else ->
        anything_else
    end
  end
end
