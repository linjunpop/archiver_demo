defmodule Archiver.GoogleDrive.DynamicSupervisor do
  use DynamicSupervisor

  alias Archiver.GoogleDrive.User.Supervisor
  alias Archiver.GoogleDrive.Recording
  alias Archiver.GoogleDrive.User.Worker

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(user_id) do
    spec = {Supervisor, user_id: user_id}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def add_recording(%Recording{user_id: user_id} = recording) do
    GenServer.call(:"#{Worker}.#{user_id}", {:add, recording})
  end
end
