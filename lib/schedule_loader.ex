defmodule ForgeMasterBot.ScheduleLoader do
  require Logger
  alias ForgeMasterBot.{Reminder, Scheduler}

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {Task, :start_link, [&load/0]},
      restart: :transient
    }
  end

  def load do
    path = Application.get_env(:forge_master_bot, :schedule_file, "schedule.yml")

    case YamlElixir.read_from_file(path) do
      {:ok, %{"jobs" => jobs} = data} when is_list(jobs) ->
        timezone = normalize_timezone(Map.get(data, "timezone", "Etc/UTC"))
        added = Enum.count(jobs, &add_job(&1, timezone))
        Logger.info("Loaded #{added} scheduled message(s) from #{path}")

      {:ok, _} ->
        Logger.warning("Schedule file #{path} is missing a `jobs:` list")

      {:error, reason} ->
        Logger.warning("Could not read schedule file #{path}: #{inspect(reason)}")
    end
  end

  defp add_job(%{"cron" => cron, "channel_id" => channel_id, "message" => message}, timezone)
       when is_binary(cron) and is_binary(message) do
    with {:ok, channel_id} <- resolve_channel_id(channel_id),
         {:ok, expression} <- Crontab.CronExpression.Parser.parse(cron) do
      job =
        Scheduler.new_job()
        |> Quantum.Job.set_schedule(expression)
        |> Quantum.Job.set_task({Reminder, :send, [channel_id, message]})
        |> Quantum.Job.set_timezone(timezone)

      Scheduler.add_job(job)
      true
    else
      {:error, reason} ->
        Logger.warning("Invalid cron expression #{inspect(cron)}: #{inspect(reason)}")
        false

      :error ->
        false
    end
  end

  defp add_job(entry, _timezone) do
    Logger.warning("Skipping malformed schedule entry: #{inspect(entry)}")
    false
  end

  # channel_id may be a literal integer or the name of an env var (e.g. CHANNEL_ID)
  # so the real ID can live in .env instead of the committed schedule file.
  defp resolve_channel_id(id) when is_integer(id), do: {:ok, id}

  defp resolve_channel_id(name) when is_binary(name) do
    case System.get_env(name) do
      nil ->
        Logger.warning("Schedule references env var #{name}, but it is not set")
        :error

      value ->
        case Integer.parse(value) do
          {id, ""} ->
            {:ok, id}

          _ ->
            Logger.warning("Env var #{name} is not a valid channel ID: #{inspect(value)}")
            :error
        end
    end
  end

  defp normalize_timezone(tz) when tz in ["Etc/UTC", "UTC", "utc"], do: :utc
  defp normalize_timezone(tz) when is_binary(tz), do: tz
end
