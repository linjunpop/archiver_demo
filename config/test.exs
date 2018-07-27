use Mix.Config

config :archiver_fetcher, :port, "5002"

config :archiver_google_drive, :fetcher_api_base, "http://127.0.0.1:5002"
config :archiver_dropbox, :fetcher_api_base, "http://127.0.0.1:5001"
