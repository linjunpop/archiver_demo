defmodule Archiver.Dropbox.FetcherAdapter do
  require Logger

  alias Archiver.Dropbox.Recording

  def get_recordings do
    url = Path.join(api_base(), "recordings")

    Logger.debug("Fetching recordings from: #{url}")

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <- HTTPoison.get(url),
         {:ok, data} <- Jason.decode(body),
         data <- parse_data(data) do
      {:ok, data}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: _}} ->
        {:error, body}
    end
  end

  defp api_base do
    Application.get_env(:archiver_dropbox, :fetcher_api_base)
  end

  defp parse_data(data) do
    data
    |> Enum.map(&parse_recording/1)
  end

  defp parse_recording({_id, recording}) do
    struct(Recording, %{
      id: recording["id"],
      uri: recording["uri"],
      status: recording["status"]
    })
  end
end
