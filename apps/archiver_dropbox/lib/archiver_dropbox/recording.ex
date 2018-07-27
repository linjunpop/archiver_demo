defmodule Archiver.Dropbox.Recording do
  @enforce_keys [:id, :uri, :status]

  defstruct([:id, :uri, :status])
end

defimpl Jason.Encoder, for: Archiver.Dropbox.Recording do
  def encode(value, opts) do
    value
    |> Map.take([:id, :uri, :status])
    |> Jason.Encode.map(opts)
  end
end
