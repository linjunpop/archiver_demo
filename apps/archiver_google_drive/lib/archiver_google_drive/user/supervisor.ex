defmodule Archiver.GoogleDrive.User.Supervisor do
  use Supervisor

  alias Archiver.GoogleDrive.User.Worker
  alias Archiver.GoogleDrive.User.Scheduler

  def start_link([user_id: user_id] = arg) do
    Supervisor.start_link(__MODULE__, arg, name: :"#{__MODULE__}.#{user_id}")
  end

  @impl true
  def init(user_id: user_id) do
    children = [
      {Worker, user_id},
      {Scheduler, user_id}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
