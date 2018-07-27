defmodule Archiver.Dropbox.Downloader do
  require Logger

  alias Archiver.Dropbox.Recording

  def download_file(%Recording{id: id, uri: uri} = _recording) do
    Logger.info("Fake downloading recording: #{id}, of: #{uri}")

    :ok
  end
end
