# Forge Master Bot

Discord bot for the Forge Master clan. Sends scheduled reminder messages to configured channels.

## Setup

- Install [asdf](https://asdf-vm.com/)
- Run `asdf install` to install elixir and erlang
- Run `mix deps.get` to install dependencies
- Put your bot token in `.env` as `TOKEN=...`
- Run `mix run --no-halt` to run the bot

## Scheduling messages

Edit `schedule.yml` at the project root. Example:

```yaml
timezone: Etc/UTC

jobs:
  - cron: "0 12 * * *"
    channel_id: 123456789012345678
    message: "Time to do your dailies!"
  - cron: "0 20 * * 5"
    channel_id: 123456789012345678
    message: "Friday clan war reminder!"
```

- `cron` uses standard 5-field syntax (see [crontab.guru](https://crontab.guru)).
- `channel_id` is the Discord channel ID as an integer.
- `message` is the string to post.
- `timezone` is optional and applies to all jobs. UTC by default. For non-UTC timezones, add `{:tzdata, "~> 1.1"}` to `mix.exs`.

Restart the bot after editing the file.

## Before committing

- Run `mix format` to format your code
