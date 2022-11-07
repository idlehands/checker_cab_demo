defmodule CheckerCabDemoWeb.UserView do
  use CheckerCabDemoWeb, :view
  alias CheckerCabDemoWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      # favorite_color: user.favorite_color,
      age: user.age,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
