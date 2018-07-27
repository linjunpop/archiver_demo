defmodule Archiver.DropboxTest do
  use ExUnit.Case
  doctest Archiver.Dropbox

  test "greets the world" do
    assert Archiver.Dropbox.hello() == :world
  end
end
