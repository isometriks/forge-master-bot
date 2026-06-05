defmodule ForgeMasterBot.Reminder do
  require Logger
  alias Nostrum.Api

  def send(channel_id, message) when is_integer(channel_id) and is_binary(message) do
    case Api.Message.create(channel_id, message) do
      {:ok, _} ->
        :ok

      {:error, error} ->
        Logger.error("Failed to send reminder to channel #{channel_id}: #{inspect(error)}")
        :error
    end
  end
end
