defmodule CheckerCabDemoWeb.UserController do
  use CheckerCabDemoWeb, :controller

  alias CheckerCabDemo.Accounts
  alias CheckerCabDemo.Accounts.User

  action_fallback CheckerCabDemoWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end
end
