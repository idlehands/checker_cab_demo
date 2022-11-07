defmodule CheckerCabDemo.IdleFactory do
  def valid_params_for(schema, opts \\ []) do
    key_type = Keyword.get(opts, :key_type, :atoms)
    skip_fields = Keyword.get(opts, :skip_fields, [])

    generators = %{
      Ecto.UUID => fn -> Ecto.UUID.generate() end,
      id: fn -> Enum.random(1..1000) end,
      binary_id: fn -> Ecto.UUID.generate() end,
      boolean: fn -> Enum.random([true, false]) end,
      float: fn -> :rand.uniform() * 10 end,
      integer: fn -> Enum.random(1..10_000) end,
      string: fn -> Enum.random(["pink", "orange", "bob", "blue", "geoff", "natalie", "sue"]) end,
      utc_datetime_usec: fn -> DateTime.utc_now() end,
      utc_datetime: fn -> DateTime.utc_now() end
    }

    actual_fields_with_types =
      for field <- schema.__schema__(:fields), field not in skip_fields do
        type = field_type(schema, field)

        {field, type}
      end

    params_by_type(actual_fields_with_types, generators, key_type)
  end

  defp params_by_type(actual_fields_with_types, generators, key_type) do
    for {field, type} <- actual_fields_with_types, into: %{} do
      case key_type do
        :atoms -> {field, value_by_type(generators, type)}
        :strings -> {Atom.to_string(field), value_by_type(generators, type)}
      end
    end
  end

  defp value_by_type(generators, type) do
    default = fn -> raise("generator undefined for type: #{inspect(type)}") end
    generator = Map.get(generators, type, default)
    generator.()
  end

  defp field_type(module, field) do
    simplified_type(module.__schema__(:type, field))
  end

  def simplified_type({:parameterized, Ecto.Embedded, %Ecto.Embedded{related: embedded_type}}) do
    {:embedded_schema, embedded_type}
  end

  def simplified_type({:parameterized, Ecto.Enum, enum_data}) do
    {Ecto.Enum, Keyword.keys(enum_data.mappings)}
  end

  def simplified_type(standard_type) do
    standard_type
  end
end
