defmodule TestCasePhoenixWeb.UserController do
  use TestCasePhoenixWeb, :controller
  alias TestCasePhoenix.Users

  def create(conn, params) do
    case Users.login_or_register(params["user"]) do
      {:ok, user} -> 
        conn 
        |> Guardian.Plug.sign_in(TestCasePhoenix.Guardian, user)
        |> redirect(to: "/")
      {:error, _reason} -> 
        conn
        |> put_flash("password", "incorrect pasword")
        |> redirect(to: "/login")
    end
  end

  def logout(conn, _params) do
    IO.inspect conn
    conn
    |> Guardian.Plug.sign_out(TestCasePhoenix.Guardian, [])
    |> redirect(to: "/login")
  end
end
