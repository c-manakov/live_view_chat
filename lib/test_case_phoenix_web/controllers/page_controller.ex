defmodule TestCasePhoenixWeb.PageController do
  use TestCasePhoenixWeb, :controller

  def index(conn, _params) do
    IO.inspect fetch_session(conn)
    render(conn, "index.html")
  end
end
