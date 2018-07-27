defmodule Archiver.SharedTest do
  use ExUnit.Case
  doctest Archiver.Shared

  test "greets the world" do
    assert Archiver.Shared.hello() == :world
  end
end
