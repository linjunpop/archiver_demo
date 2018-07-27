defmodule Archiver.UI.FetcherAdapter do
  require Logger

  def get_recordings do
    url = Path.join(api_base(), "recordings")

    Logger.debug("Fetching recordings from: #{url}")

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           HTTPoison.get(url, [], timeout: 50_000, recv_timeout: 50_000),
         {:ok, data} <- Jason.decode(body) do
      {:ok, data}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: _}} ->
        {:error, body}
    end
  end

  def fetch_recordings do
    url = Path.join(api_base(), "fetch")

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
    Application.get_env(:archiver_ui, :fetcher_api_base)
  end
end
