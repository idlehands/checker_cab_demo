defmodule CheckerCabDemoWeb.PageController do
  use CheckerCabDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
