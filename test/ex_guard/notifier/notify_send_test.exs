defmodule ExGuard.Notifier.NotifySendTest do
  use ExUnit.Case

  alias ExGuard.Notifier.NotifySend

  test "prepare TerminalNotifier command" do
    command = NotifySend.prepare_cmd(title: "unit test", message: "boo", icon: "icon.png", content_image: "pending.png")
    assert command == ~s(notify-send --app-name=ExGuard --icon="icon.png" "unit test" "boo")
  end
end
