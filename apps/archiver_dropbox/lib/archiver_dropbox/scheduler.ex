defmodule Archiver.Dropbox.Scheduler do
  use GenServer
  require Logger

  alias Archiver.Dropbox.FetcherAdapter
  alias Archiver.Dropbox.Queue

  @doc false
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :state, name: __MODULE__)
  end

  @impl GenServer
  def init(_state) do
    do_schedule(:fetch_recordings, 2)
    do_schedule(:download, 3)

    {:ok, %{}}
  end

  @impl GenServer
  def handle_info({:schedule, :fetch_recordings}, state) do
    with {:ok, recordings} <- FetcherAdapter.get_recordings() do
      recordings
      |> Enum.each(&Queue.enqueue/1)
    else
      {:error, err} ->
        Logger.error(inspect(err))
    end

    do_schedule(:fetch_recordings, 60)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:schedule, :download}, state) do
    with {:ok, recordings} <- Queue.dequeue(1_000) do
      recordings
      |> Enum.map(fn recording ->
        Task.async(fn ->
          :poolboy.transaction(
            :dropbox_worker,
            fn pid -> GenServer.call(pid, {:download_file, recording}) end,
            60_000
          )
        end)
      end)
      |> Enum.each(&Task.await(&1, 10_000))
    else
      {:error, err} ->
        Logger.error(inspect(err))

      {:warn, err} ->
        Logger.warn(inspect(err))
    end

    do_schedule(:download, 5)

    {:noreply, state}
  end

  # private

  # schedule in seconds
  defp do_schedule(category, seconds) do
    Process.send_after(self(), {:schedule, category}, seconds * 1000)
  end
end
