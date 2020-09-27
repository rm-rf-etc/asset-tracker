defmodule ExSqliteMarketDbTest do
  use ExUnit.Case
  doctest ExSqliteMarketDb

  test "greets the world" do
    assert ExSqliteMarketDb.hello() == :world
  end
end
