use Mix.Config

config :archiver_fetcher, :port, "${FETCHER_PORT}"
config :archiver_google_drive, :port, "${GOOGLE_DRIVE_PORT}"
config :archiver_ui, :port, "${UI_PORT}"

config :archiver_google_drive, :fetcher_api_base, "${FETCHER_API_BASE}"
config :archiver_dropbox, :fetcher_api_base, "${FETCHER_API_BASE}"

config :archiver_ui, :fetcher_api_base, "${FETCHER_API_BASE}"
config :archiver_ui, :google_drive_api_base, "${GOOGLE_DRIVE_API_BASE}"
