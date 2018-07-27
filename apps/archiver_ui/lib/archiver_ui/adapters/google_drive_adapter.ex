defmodule Archiver.UI.GoogleDriveAdapter do
  require Logger

  def get_workers do
    url = Path.join(api_base(), "workers")

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           HTTPoison.get(url, [], timeout: 50_000, recv_timeout: 50_000),
         {:ok, data} <- Jason.decode(body) do
      {:ok, data}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: _}} ->
        {:error, body}
    end
  end

  def work do
    url = Path.join(api_base(), "work")

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           HTTPoison.get(url, [], timeout: 50_000, recv_timeout: 50_000),
         {:ok, data} <- Jason.decode(body) do
      {:ok, data}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: _}} ->
        {:error, body}
    end
  end

  defp api_base do
    Application.get_env(:archiver_ui, :google_drive_api_base)
  end
end
