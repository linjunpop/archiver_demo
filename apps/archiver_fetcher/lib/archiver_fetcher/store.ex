defmodule Archiver.Fetcher.Store do
  use GenServer
  require Logger

  alias Archiver.Fetcher.Recording

  @doc false
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :state, name: __MODULE__)
  end

  @impl GenServer
  def init(_state) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:put, id, recording}, _from, state) do
    Logger.debug("Storing recording item: #{id}, #{inspect(recording)}")

    state =
      state
      |> Map.put(id, recording)

    {:reply, {:ok, recording}, state}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    value = Map.get(state, key, nil)

    {:reply, value, state}
  end

  @impl GenServer
  def handle_call(:get_pending, _from, state) do
    pending_recordings =
      state
      |> Enum.filter(fn {_id, recording} -> recording.status == "pending" end)
      |> Enum.into(%{})

    {:reply, {:ok, pending_recordings}, state}
  end

  ## Client API ##

  def pending_recordings do
    GenServer.call(__MODULE__, :get_pending)
  end

  def get_recording(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def store_recordings(recordings) do
    recordings
    |> Flow.from_enumerable()
    |> Flow.each(&store_recording/1)
    |> Flow.run()
  end

  def store_recording(%Recording{id: id} = recording) do
    put(id, recording)
  end

  def update_recording(id, %Recording{} = recording) do
    put(id, recording)
  end

  defp put(key, %Recording{} = value) do
    GenServer.call(__MODULE__, {:put, key, value})
  end
end
