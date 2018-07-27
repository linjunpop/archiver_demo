defmodule Archiver.UI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Archiver.UI.Worker.start_link(arg)
      # {Archiver.UI.Worker, arg},
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: Archiver.UI.Web.Router,
        options: [port: Application.get_env(:archiver_ui, :port) |> String.to_integer()]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Archiver.UI.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
