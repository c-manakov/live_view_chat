defmodule TestCasePhoenix.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Argon2

  schema "users" do
    field :is_admin, :boolean, default: false
    field :is_banned, :boolean, default: false
    field :is_muted, :boolean, default: false
    field :login, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:login, :password, :is_admin, :is_banned, :is_muted])
    |> validate_required([:login, :password, :is_admin, :is_banned, :is_muted])
  end

  def put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  def put_password_hash(changeset), do: changeset
end
