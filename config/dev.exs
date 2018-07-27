use Mix.Config

config :archiver_fetcher, :port, "5001"
config :archiver_google_drive, :port, "5003"
config :archiver_ui, :port, "5002"

config :archiver_google_drive, :fetcher_api_base, "http://127.0.0.1:5001"
config :archiver_dropbox, :fetcher_api_base, "http://127.0.0.1:5001"

config :archiver_ui, :fetcher_api_base, "http://127.0.0.1:5001"
config :archiver_ui, :google_drive_api_base, "http://127.0.0.1:5003"

config :logger, :console,
  level: :debug,
  metadata: [:module]
