defmodule TestCasePhoenix.UserServer do
  use Agent
  alias TestCasePhoenix.Users
  alias __MODULE__, as: UserServer
  @user_topic "users"

  def start_link(_args) do
    users = Users.get_all_by_id
            |> Enum.map(fn {k, v} -> {k, Map.put(v, :online, false)} end)
            |> Enum.into(%{})
    Agent.start_link(fn -> users end, name: UserServer)
  end


  def add_user(user) do
    users = Map.put(Agent.get(UserServer, & &1), user.id, user)

    Agent.update(UserServer, fn _ -> users end)
    broadcast_users()
  end

  def set_online_status(new_status, user_id) do
    Agent.update(UserServer, fn users 
      -> Map.update!(users, user_id, fn user 
        -> Map.put(user, :online, new_status)
      end) 
    end)

    broadcast_users()
  end

  def set_mute_status(new_status, user_id) do
    user = Agent.get(UserServer, & &1[user_id])
     
    {:ok, new_user} = Users.set_mute_status(new_status, user)

    Agent.update(UserServer, & Map.put(&1, user_id, new_user))
    broadcast_users()
  end

  def set_ban_status(new_status, user_id) do
    user = Agent.get(UserServer, & &1[user_id])
     
    {:ok, new_user} = Users.set_ban_status(new_status, user)

    Agent.update(UserServer, & Map.put(&1, user_id, new_user))
    broadcast_users()
  end

  def get_users do
    Agent.get(UserServer, & &1)
  end

  defp broadcast_users do
    Phoenix.PubSub.broadcast(TestCasePhoenix.PubSub, @user_topic, {:users, Agent.get(UserServer, & &1)})
  end
end
