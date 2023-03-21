defmodule IbmWatsonAssistantTest do
  use ExUnit.Case
  doctest IbmWatsonAssistant

  test "greets the world" do
    assert IbmWatsonAssistant.hello() == :world
  end
end
