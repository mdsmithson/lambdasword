defmodule LambdaswordTest do
  use ExUnit.Case
  doctest Lambdasword

  test "greets the world" do
    assert Lambdasword.hello() == :world
  end
end
