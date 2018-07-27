defmodule Archiver.GoogleDrive.Scheduler do
  use GenServer
  require Logger

  alias Archiver.GoogleDrive.FetcherAdapter
  alias Archiver.GoogleDrive.DynamicSupervisor

  @doc false
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :state, name: __MODULE__)
  end

  @impl GenServer
  def init(_state) do
    do_schedule(:fetch_recordings, 2)

    {:ok, %{}}
  end

  @impl GenServer
  def handle_info({:schedule, :fetch_recordings}, state) do
    with {:ok, recordings} <- FetcherAdapter.get_recordings() do
      recordings
      |> Enum.each(&GenServer.cast(__MODULE__, {:enqueue, &1}))
    else
      {:error, err} ->
        Logger.error(inspect(err))
    end

    do_schedule(:fetch_recordings, 60)

    {:noreply, state}
  end

  @impl GenServer
  @doc """

  """
  def handle_cast({:enqueue, recording}, state) do
    # start a user queue
    DynamicSupervisor.start_child(recording.user_id)

    # add recording to user's own queue
    DynamicSupervisor.add_recording(recording)

    {:noreply, state}
  end

  # private

  # schedule in seconds
  defp do_schedule(category, seconds) do
    Process.send_after(self(), {:schedule, category}, seconds * 1000)
  end
end
