defmodule Archiver.GoogleDrive.User.Scheduler do
  use GenServer
  require Logger

  alias Archiver.GoogleDrive.User.Worker

  @doc false
  def start_link(user_id) do
    GenServer.start_link(__MODULE__, user_id, name: :"#{__MODULE__}.#{user_id}")
  end

  @impl GenServer
  def init(user_id) do
    do_schedule(:download, 3)

    {:ok, user_id}
  end

  @impl GenServer
  def handle_info({:schedule, :download}, user_id) do
    GenServer.cast(:"#{Worker}.#{user_id}", {:work_in_batch, 200})

    do_schedule(:download, 1)

    {:noreply, user_id}
  end

  # private

  # schedule in seconds
  defp do_schedule(category, seconds) do
    Process.send_after(self(), {:schedule, category}, seconds * 1000)
  end
end
