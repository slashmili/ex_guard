defmodule ExGuard.ConfigTest do
  use ExUnit.Case, async: false
  use ExGuard.Config

  setup do
    {:ok, _pid} = ExGuard.Config.start_link
    :ok
  end

  test "add guard" do
    guard_struct = %ExGuard.Guard{title: "foobar"}
    assert guard("foobar") == guard_struct
    assert ExGuard.Config.get_guard("foobar") == guard_struct
  end

  test "add extra settings" do
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "mix test", watch: [~r/foo/, ~r/bar/], ignore: [~r/foo/]}
    guard("foobar")
    |> command("mix test")
    |> watch(~r/foo/)
    |> watch(~r/bar/)
    |> ignore(~r/foo/)

    assert ExGuard.Config.get_guard("foobar") == guard_struct
  end

  test "add tuple watch " do
    watch_file = {~r/foo/, fn(m) -> "test/foo#{m[1]}" end}
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "mix test", watch: [watch_file]}
    guard("foobar")
    |> command("mix test")
    |> watch(watch_file)

    assert ExGuard.Config.get_guard("foobar") == guard_struct
  end

  test "match a path" do
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "mix test", watch: [~r/test\/*.exs$/], notification: :off}
    guard("foobar")
    |> command("mix test")
    |> watch(~r/test\/*.exs$/)
    |> notification(:off)

    guards = ExGuard.Config.match_guards("/home/milad/dev/ex_guard/test/ex_guard/config_test.exs")
    assert guards == [{guard_struct, []}]
  end

  test "watch web dir in a phoenix project" do
    watch_phoenix = {~r{web/(?<dir>.+)/(?<file>.+).ex$}, fn(m) -> "test/#{m["dir"]}/#{m["file"]}_test.exs" end}
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "mix test", watch: [watch_phoenix]}
    guard("foobar")
    |> command("mix test")
    |> watch(watch_phoenix)

    guards = ExGuard.Config.match_guards("web/models/elink.ex")
    assert guards == [{guard_struct, ["test/models/elink_test.exs"]}]
  end

  test "doesn't match with path" do
    guard("foobar")
    |> command("mix test")
    |> watch(~r/test\/*.exs$/)
    |> notification(:off)

    guards = ExGuard.Config.match_guards("/home/milad/dev/ex_guard/mix.lock")
    assert guards == []
  end

  test "watches on a dir" do
    guard("foobar")
    |> command("mix test")
    |> watch("assets/")
    |> notification(:off)

    guards = ExGuard.Config.match_guards("/home/milad/dev/elide/assets/js/foo.js")
    assert guards == []
  end

  test "watches on a list of files" do
    guard("foobar")
    |> command("mix test")
    |> watch(["assets/", "mix.exs"])
    |> notification(:off)

    guards = ExGuard.Config.match_guards("/home/milad/dev/elide/mix.exs")
    assert guards == []
  end

  test "shouldn't match beacuse of path is ignored" do
    guard("foobar")
    |> command("mix test")
    |> watch(~r/test\/*.exs$/)
    |> ignore(~r/ignored_dir/)

    guards = ExGuard.Config.match_guards("/home/milad/dev/ex_guard/test/ex_guard/ignored_dir/config_test.exs")
    assert guards == []
  end

  test "loading a ExGuardfile" do
    ExGuard.Config.load("test/sample_ExGuardfile")

    guard_struct = %ExGuard.Guard{title: "unit-test", cmd: "mix test --color", watch: [~r/\.(erl|ex|exs|eex|xrl|yrl)\z/i], notification: :auto}

    assert ExGuard.Config.get_guard("unit-test") == guard_struct
  end
end
