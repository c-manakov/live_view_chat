defmodule TestCasePhoenix.Guardian do
  use Guardian, otp_app: :test_case_phoenix
  alias TestCasePhoenixWeb.Router.Helpers, as: Routes
  alias TestCasePhoenix.Users

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Users.get(id)
    {:ok,  resource}
  end
end


defmodule TestCasePhoenix.Guardian.ErrorHandler do
  import Plug.Conn
  use TestCasePhoenixWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, _error, _opts) do
    conn
    |> redirect(to: "/login")
    |> halt()
  end
end


defmodule TestCasePhoenix.AuthPipeline do
  use Guardian.Plug.Pipeline, 
    otp_app: :test_case_phoenix, 
    error_handler: TestCasePhoenix.Guardian.ErrorHandler,
    module: TestCasePhoenix.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
