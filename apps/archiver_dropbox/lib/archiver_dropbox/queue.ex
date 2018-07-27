defmodule Archiver.Dropbox.Queue do
  use GenServer
  require Logger

  @doc false
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :state, name: __MODULE__)
  end

  @impl GenServer
  def init(_state) do
    {:ok, []}
  end

  @impl GenServer
  def handle_call({:enqueue, recording}, _from, state) do
    Logger.debug("Enqueue recording: #{inspect(recording.id)}")

    state = [recording | state]

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:dequeue, _count}, _from, [] = state) do
    {:reply, {:warn, "Queue is empty"}, state}
  end

  def handle_call({:dequeue, count}, _from, state) do
    recordings = Enum.take(state, count)

    Logger.debug("Dequeue recordings #{recordings |> Enum.map(& &1.id)}")

    new_state = Enum.drop(state, count)

    {:reply, {:ok, recordings}, new_state}
  end

  ## Client API ##

  def enqueue(recording) do
    GenServer.call(__MODULE__, {:enqueue, recording})
  end

  def dequeue(count \\ 1) when count > 0 do
    GenServer.call(__MODULE__, {:dequeue, count})
  end
end
