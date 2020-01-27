defmodule TestCasePhoenixWeb.Login do
  use Phoenix.LiveView
  use Phoenix.HTML
  import TestCasePhoenixWeb.ErrorHelpers
  alias TestCasePhoenix.User
  alias TestCasePhoenixWeb.Router.Helpers, as: Routes
  alias TestCasePhoenix.Users
  alias Guardian.Phoenix.Socket

  def render(assigns) do
    IO.inspect assigns
    ~L"""
    <%= f = form_for @changeset, Routes.user_path(TestCasePhoenixWeb.Endpoint, :create), [phx_change: :validate] %>
      Login: <%= text_input f, :login %>
      <%= error_tag f, :login %>

      Password: <%= password_input f, :password, value: input_value(f, :password) %>
      <%= error_tag f, :password %>

      <%= submit "Save" %>
    </form>
    """
  end

  def mount(_, socket) do
    {:ok, assign(socket, %{changeset: User.changeset(%User{})})}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> User.changeset(params)
      |> Map.put(:action, :insert)

    IO.inspect changeset

    {:noreply, assign(socket, changeset: changeset)}
  end

end
