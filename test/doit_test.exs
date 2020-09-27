defmodule DoitTest do
  use ExUnit.Case
  doctest Doit

  test "greets the world" do
    assert Doit.hello() == :world
  end
end
