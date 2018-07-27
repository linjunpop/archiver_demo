defmodule Archiver.UITest do
  use ExUnit.Case
  doctest Archiver.UI

  test "greets the world" do
    assert Archiver.UI.hello() == :world
  end
end
