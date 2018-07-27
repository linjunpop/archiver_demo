defmodule Archiver.Fetcher.Web.Router do
  use Plug.Router
  require Logger

  alias Archiver.Fetcher.Client
  alias Archiver.Fetcher.Store
  alias Archiver.Fetcher.Recording

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/recordings" do
    {:ok, recordings} = Store.pending_recordings()
    {:ok, json} = Jason.encode(recordings)

    send_resp(conn, 200, json)
  end

  put "/recording/:recording_id" do
    recording = conn.body_params

    {:ok, updated} =
      Store.update_recording(
        recording_id,
        struct(Recording, %{
          id: recording["id"],
          uri: recording["uri"],
          status: recording["status"]
        })
      )

    send_resp(conn, 200, Jason.encode!(updated))
  end

  get "/fetch" do
    {:ok, recordings} = Client.get_calllogs("~")
    Store.store_recordings(recordings)

    send_resp(conn, 200, "{}")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
