defmodule ExGuard.ConfigTest do
  use ExUnit.Case
  use ExGuard.Config

  setup do
    {:ok, pid} = ExGuard.Config.start_link
    :ok
  end

  test "add guard" do
    guard_struct = %ExGuard.Guard{title: "foobar"}
    assert guard("foobar") == guard_struct
    assert ExGuard.Config.get_guard("foobar") == guard_struct
  end

  test "add extra settings" do
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "mix test", watch: [~r/foo/, ~r/bar/]}
    guard("foobar")
    |> command("mix test")
    |> watch(~r/foo/)
    |> watch(~r/bar/)

    assert ExGuard.Config.get_guard("foobar") == guard_struct
  end
end
