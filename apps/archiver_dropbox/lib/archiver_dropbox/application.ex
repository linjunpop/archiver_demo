defmodule Archiver.Dropbox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Archiver.Dropbox.Worker.start_link(arg)
      # {Archiver.Dropbox.Worker, arg},
      Archiver.Dropbox.Queue,
      # Archiver.Dropbox.Scheduler,
      :poolboy.child_spec(:worker, [
        {:name, {:local, :dropbox_worker}},
        {:worker_module, Archiver.Dropbox.Worker},
        {:size, 20},
        {:max_overflow, 2}
      ])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Archiver.Dropbox.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
