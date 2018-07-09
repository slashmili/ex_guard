defmodule ExGuard.Notifier.TerminalTitleTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias ExGuard.Notifier.TerminalTitle

  test "change terminal title" do
    assert capture_io(:stderr, fn ->
             TerminalTitle.notify(title: "unit test", message: "boo")
           end) == "\e]2;[unit test] boo \a\n"
  end
end
