defmodule Archiver.Fetcher.Scheduler do
  use GenServer
  require Logger

  alias Archiver.Fetcher.Client
  alias Archiver.Fetcher.Store

  # sec
  @schedule 90

  @doc false
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :state, name: __MODULE__)
  end

  @impl GenServer
  def init(_state) do
    # do_schedule(1)

    {:ok, 1}
  end

  @impl GenServer
  def handle_info(:schedule, state) do
    Logger.debug("Start fetching calllogs")

    with {:ok, recordings} <- Client.get_calllogs("~") do
      Store.store_recordings(recordings)
    else
      {:error, err} ->
        Logger.error(inspect(err))
    end

    # do_schedule(@schedule)
    {:noreply, state}
  end

  # private

  # schedule in seconds
  defp do_schedule(seconds) do
    Process.send_after(self(), :schedule, seconds * 1000)
  end
end
