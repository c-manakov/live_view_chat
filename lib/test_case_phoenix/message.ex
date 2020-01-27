defmodule TestCasePhoenix.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text, :user_id])
  end
end
