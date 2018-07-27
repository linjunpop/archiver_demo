defmodule Archiver.Fetcher.Client do
  alias Archiver.Fetcher.Recording

  @mock_userids 1..2000

  def get_calllogs(_account_id) do
    with {:ok, json} <- File.read(Application.app_dir(:archiver_fetcher, "priv/sample.json")),
         {:ok, data} <- Jason.decode(json) do
      recordings = parse_recordings(data)

      {:ok, recordings}
    end
  end

  def parse_recordings(data) do
    data
    |> Map.get("records")
    |> List.duplicate(10000)
    |> List.flatten()
    |> Flow.from_enumerable()
    |> Flow.map(&parse_recording/1)
    |> Enum.to_list()
  end

  def parse_recording(recording) when is_map(recording) do
    id = Nanoid.generate()

    uri =
      recording
      |> Map.get("uri")

    struct(Recording, %{
      id: id,
      uri: uri,
      status: "pending",
      user_id: Enum.random(@mock_userids)
    })
  end
end
