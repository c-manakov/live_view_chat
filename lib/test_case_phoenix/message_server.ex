defmodule TestCasePhoenix.MessageServer do
  use Agent
  alias TestCasePhoenix.Messages
  @message_topic "messages"

  def start_link(_args) do
    messages  = Messages.get_all
    Agent.start_link(fn -> messages end, name: __MODULE__)
  end

  def add_message(message) do
    {:ok, message} = Messages.add_message(message) 
    Agent.update(__MODULE__, fn messages -> [message | messages] end)  
    Phoenix.PubSub.broadcast(TestCasePhoenix.PubSub, @message_topic, {:messages, get_messages()})
  end

  def get_messages do
    Enum.reverse(Agent.get(__MODULE__, & &1))
  end
end
