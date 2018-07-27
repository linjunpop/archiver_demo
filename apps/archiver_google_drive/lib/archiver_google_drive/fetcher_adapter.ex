defmodule Archiver.GoogleDrive.FetcherAdapter do
  require Logger

  alias Archiver.GoogleDrive.Recording

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

  def update_recording_status(%Recording{id: id} = recording, status) do
    url = Path.join(api_base(), "recording/#{id}")

    headers = [
      {"content-type", "application/json"}
    ]

    {:ok, json} = Jason.encode(%{recording | status: status})

    Logger.debug("Trying to update recording status: #{id}, to: #{status}")

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           HTTPoison.put(url, json, headers),
         {:ok, data} <- Jason.decode(body) do
      {:ok, data}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: _}} ->
        {:error, body}
    end
  end

  defp api_base do
    Application.get_env(:archiver_google_drive, :fetcher_api_base)
  end

  defp parse_data(data) do
    data
    |> Enum.map(&parse_recording/1)
  end

  defp parse_recording({_id, recording}) do
    struct(Recording, %{
      id: recording["id"],
      uri: recording["uri"],
      status: recording["status"],
      user_id: recording["user_id"]
    })
  end
end
