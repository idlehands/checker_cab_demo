defmodule CheckerCabDemo.Accounts.User do
  use CheckerCabDemo.Schema

  schema "users" do
    field :age, :integer
    field :name, :string
    # field :favorite_color, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
