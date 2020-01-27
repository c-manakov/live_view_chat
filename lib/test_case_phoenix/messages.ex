defmodule TestCasePhoenix.Messages do
  import Ecto.Query, warn: false
  alias TestCasePhoenix.Repo
  alias TestCasePhoenix.Message

  def add_message(message_params) do
    message = Message.changeset(%Message{}, message_params)  
    Repo.insert(message)
  end

  def get_all do
    Repo.all(from m in Message, order_by: [desc: m.inserted_at])
  end
end
