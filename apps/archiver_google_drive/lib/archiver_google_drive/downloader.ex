defmodule Archiver.GoogleDrive.Downloader do
  require Logger

  alias Archiver.GoogleDrive.Recording
  alias Archiver.GoogleDrive.FetcherAdapter

  def download_file(%Recording{id: id, uri: uri} = recording) do
    Logger.info("Fake downloading recording: #{id}, of: #{uri}")

    {:ok, _} = FetcherAdapter.update_recording_status(recording, "google_drive")

    :ok
  end
end
