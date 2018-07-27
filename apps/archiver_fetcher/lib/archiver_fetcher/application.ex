defmodule Archiver.Fetcher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Archiver.Fetcher.Worker.start_link(arg)
      # {Archiver.Fetcher.Worker, arg},
      # Archiver.Fetcher.Scheduler,
      Archiver.Fetcher.Store,
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: Archiver.Fetcher.Web.Router,
        options: [port: Application.get_env(:archiver_fetcher, :port) |> String.to_integer()]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Archiver.Fetcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
