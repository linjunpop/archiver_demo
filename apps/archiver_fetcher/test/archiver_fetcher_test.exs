defmodule Archiver.FetcherTest do
  use ExUnit.Case
  doctest Archiver.Fetcher

  test "greets the world" do
    assert Archiver.Fetcher.hello() == :world
  end
end
