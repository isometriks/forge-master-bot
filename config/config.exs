import Config

# Scheduled messages live in schedule.yml at the project root.
# Override the path here if needed:
# config :forge_master_bot, schedule_file: "/path/to/schedule.yml"

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
