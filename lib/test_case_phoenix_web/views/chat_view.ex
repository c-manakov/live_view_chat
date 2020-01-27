defmodule TestCasePhoenixWeb.Chat do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias TestCasePhoenix.MessageServer
  alias TestCasePhoenix.UserServer
  alias TestCasePhoenix.Message
  @message_topic "messages"
  @user_topic "users"
  # import TestCasePhoenixWeb.ErrorHelpers
  # alias TestCasePhoenix.User
  # alias TestCasePhoenixWeb.Router.Helpers, as: Routes
  # alias TestCasePhoenix.Users
  # alias Guardian.Phoenix.Socket

  def render(assigns) do
    ~L"""
    <%= for message <- @messages do %> 
      <div><b><%= @users[message.user_id].login %></b></div>
      <div><%= message.text %></div>
    <% end %>
    <h3>Users start here</h3>
    <%= for {_id, user} <- @users do %> 
      <%= if @current_user.is_admin or user.online do %>
        <div><%= user.login %></div>
        <%= if @current_user.is_admin do %>
          <%= if user.online do %>
            <div>Online</div>
          <% else %>
            <div>Offline</div>
          <% end %>
          <%= if user.is_muted do %>
            <button phx-click="unmute" phx-value-user-id="<%= user.id %>">Unmute</button> 
          <% else %>
            <button phx-click="mute" phx-value-user-id="<%= user.id %>">Mute</button> 
          <% end %>
          <%= if user.is_banned do %>
            <button phx-click="unban" phx-value-user-id="<%= user.id %>">Unban</button> 
          <% else %>
            <button phx-click="ban" phx-value-user-id="<%= user.id %>">Ban</button> 
          <% end %>
        <% end %>
      <% end %>
    <% end %>
    <%= f = form_for @message_changeset, "#", [phx_submit: :send] %>
    <%= text_input f, :text %>
    <%= submit "Send" %>
    </form>
    """
  end

  def mount(%{guardian_default_token: token}, socket) do
    {:ok, user, _claims} = TestCasePhoenix.Guardian.resource_from_token(token)

    case user do
      %{is_banned: false} -> 
        UserServer.set_online_status(true, user.id)  

        Phoenix.PubSub.subscribe(TestCasePhoenix.PubSub, @message_topic)
        Phoenix.PubSub.subscribe(TestCasePhoenix.PubSub, @user_topic)

        {:ok, assign(socket, %{
          message_changeset: Message.changeset(%Message{}),
          messages: MessageServer.get_messages(),
          users: UserServer.get_users(),
          current_user: user
        })}

      %{is_banned: true} ->
        {:ok, socket}
    end

  end

  def handle_info({:messages, messages}, socket) do
    {:noreply, assign(socket, %{messages: messages})}
  end

  def handle_info({:users, users}, socket) do
    current_user = users[socket.assigns[:current_user].id]
    if not current_user.is_banned do
      {:noreply, assign(socket, %{users: users, current_user: current_user})}
    else
      {:stop, socket}
    end
  end

  def handle_event("mute", %{"user-id" => user_id}, socket) do
    UserServer.set_mute_status(true, String.to_integer(user_id)) 
    {:noreply, socket}
  end

  def handle_event("unmute", %{"user-id" => user_id}, socket) do
    UserServer.set_mute_status(false, String.to_integer(user_id)) 
    {:noreply, socket}
  end

  def handle_event("ban", %{"user-id" => user_id}, socket) do
    UserServer.set_ban_status(true, String.to_integer(user_id)) 
    {:noreply, socket}
  end

  def handle_event("unban", %{"user-id" => user_id}, socket) do
    UserServer.set_ban_status(false, String.to_integer(user_id)) 
    {:noreply, socket}
  end

  def handle_event("send", %{"message" => %{"text" => text}}, socket) do
    case socket.assigns[:current_user] do
      %{is_muted: false} = current_user -> 
        MessageServer.add_message(%{text: text, user_id: current_user.id})
        {:noreply, socket}
      %{is_muted: true} -> {:noreply, socket}
    end
  end

  def terminate(_reason, socket) do
    UserServer.set_online_status(false, socket.assigns[:current_user].id)
  end

  # def handle_event("current_message", )
end
