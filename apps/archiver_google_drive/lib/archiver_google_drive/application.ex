defmodule Archiver.GoogleDrive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Archiver.GoogleDrive.Worker.start_link(arg)
      # {Archiver.GoogleDrive.Worker, arg},
      # Archiver.GoogleDrive.Scheduler,
      Archiver.GoogleDrive.DynamicSupervisor,
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: Archiver.GoogleDrive.Web.Router,
        options: [port: Application.get_env(:archiver_google_drive, :port) |> String.to_integer()]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Archiver.GoogleDrive.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
