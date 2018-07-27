defmodule Archiver.GoogleDrive.Recording do
  @enforce_keys [:id, :uri, :status, :user_id]

  defstruct([:id, :uri, :status, :user_id])
end

defimpl Jason.Encoder, for: Archiver.GoogleDrive.Recording do
  def encode(value, opts) do
    value
    |> Map.take([:id, :uri, :status])
    |> Jason.Encode.map(opts)
  end
end
