defmodule Archiver.GoogleDrive.User.Worker do
  use GenServer
  require Logger

  alias Archiver.GoogleDrive.Downloader
  alias Archiver.GoogleDrive.Recording

  @doc false
  def start_link(user_id) do
    GenServer.start_link(__MODULE__, [], name: :"#{__MODULE__}.#{user_id}")
  end

  @impl GenServer
  def init(_) do
    {:ok, []}
  end

  @impl GenServer
  def handle_call({:add, %Recording{} = recording}, _from, state) do
    state = [recording | state]

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_cast({:work_in_batch, _size}, [] = state) do
    {:noreply, state}
  end

  def handle_cast({:work_in_batch, size}, state) do
    state
    |> Enum.take(size)
    |> Flow.from_enumerable()
    |> Flow.each(fn recording -> :ok = Downloader.download_file(recording) end)
    |> Flow.run()

    {:noreply, Enum.drop(state, size)}
  end
end
