defmodule Archiver.GoogleDrive.Web.Router do
  use Plug.Router
  require Logger

  alias Archiver.GoogleDrive.FetcherAdapter

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/workers" do
    workers =
      Archiver.GoogleDrive.DynamicSupervisor
      |> DynamicSupervisor.which_children()
      |> Enum.map(fn {:undefined, pid, :supervisor, _} ->
        info = Process.info(pid)
        Keyword.get(info, :registered_name)
      end)

    {:ok, json} = Jason.encode(workers)

    send_resp(conn, 200, json)
  end

  get "/work" do
    with {:ok, recordings} <- FetcherAdapter.get_recordings() do
      recordings
      |> Stream.each(fn recording ->
        Archiver.GoogleDrive.DynamicSupervisor.start_child(recording.user_id)

        # add recording to user's own queue
        Archiver.GoogleDrive.DynamicSupervisor.add_recording(recording)
      end)
      |> Stream.run()
    else
      {:error, err} ->
        Logger.error(inspect(err))
    end

    send_resp(conn, 200, "{}")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
