defmodule ForgeMasterBot.BotConsumer do
  @behaviour Nostrum.Consumer

  def handle_event(_event), do: :noop
end
