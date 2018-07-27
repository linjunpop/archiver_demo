defmodule Archiver.Fetcher.Recording do
  @enforce_keys [:id, :uri, :status, :user_id]

  defstruct([:id, :uri, :status, :user_id])
end

defimpl Jason.Encoder, for: Archiver.Fetcher.Recording do
  def encode(value, opts) do
    value
    |> Map.take([:id, :uri, :status, :user_id])
    |> Jason.Encode.map(opts)
  end
end
