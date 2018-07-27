defmodule Archiver.Dropbox.Worker do
  use GenServer

  alias Archiver.Dropbox.Recording
  alias Archiver.Dropbox.Downloader

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:download_file, %Recording{} = recording}, _from, state) do
    result = Downloader.download_file(recording)

    {:reply, result, state}
  end
end
