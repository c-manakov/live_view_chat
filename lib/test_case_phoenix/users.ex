defmodule TestCasePhoenix.Users do
  import Ecto.Query, warn: false
  alias TestCasePhoenix.Repo
  alias Argon2
  alias TestCasePhoenix.UserServer

  alias TestCasePhoenix.User
  
  def get(id), do: Repo.get(User, id)

  def get_by_login(login), do: Repo.get_by(User, login: login)

  def login_or_register(user_params) do
    query = from u in User, where: u.login == ^user_params["login"]
    case Repo.one(query) do
      nil ->
        {:ok, user} = User.changeset(%User{}, user_params) 
        |> User.put_password_hash()
        |> Repo.insert

        UserServer.add_user(user)

        {:ok, user}
      user ->
        if Argon2.verify_pass(user_params["password"], user.password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def get_all_by_id do
    Repo.all(User)
    |> Enum.into(%{}, & {&1.id, &1})
  end

  def set_mute_status(new_status, user) do
    User.changeset(user, %{is_muted: new_status})
    |> Repo.update()
  end

  def set_ban_status(new_status, user) do
    User.changeset(user, %{is_banned: new_status})
    |> Repo.update()
  end
end
