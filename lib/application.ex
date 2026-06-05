defmodule ForgeMasterBot.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    bot_options = %{
      consumer: ForgeMasterBot.BotConsumer,
      intents: [:guild_messages],
      wrapped_token: fn -> System.fetch_env!("TOKEN") end
    }

    children = [
      {Nostrum.Bot, bot_options},
      ForgeMasterBot.Scheduler,
      ForgeMasterBot.ScheduleLoader
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
