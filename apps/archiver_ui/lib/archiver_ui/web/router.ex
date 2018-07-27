defmodule Archiver.UI.Web.Router do
  use Plug.Router
  require Logger

  alias Archiver.UI.FetcherAdapter
  alias Archiver.UI.GoogleDriveAdapter

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/" do
    {:ok, pending_recordings} = FetcherAdapter.get_recordings()

    {:ok, google_drive_workers} = GoogleDriveAdapter.get_workers()

    conn
    |> render_html(
      "index",
      pending_recordings: pending_recordings,
      google_drive_workers: google_drive_workers
    )
  end

  get "/fetch-recordings" do
    {:ok, _} = FetcherAdapter.fetch_recordings()

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(201, ~s{<meta http-equiv="refresh" content="0; URL='/'" />})
  end

  get "/gdrive-work" do
    GoogleDriveAdapter.work()

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(201, ~s{<meta http-equiv="refresh" content="0; URL='/'" />})
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp render_html(conn, template, args \\ []) when is_list(args) do
    tmeplate_dir = Application.app_dir(:archiver_ui, "priv/templates")

    page_contents = EEx.eval_file(Path.join(tmeplate_dir, "#{template}.html.eex"), args)

    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, page_contents)
  end
end
