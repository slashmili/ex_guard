defmodule ExGuard.Notifier.TerminalNotifierTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias ExGuard.Notifier.TerminalNotifier

  test "prepare TerminalNotifier command" do
    command = TerminalNotifier.prepare_cmd(title: "unit test", message: "boo", icon: "icon.png", content_image: "pending.png")
    assert command == "terminal-notifier -title unit test -message boo -appIcon icon.png -contentImage pending.png"
  end
end
