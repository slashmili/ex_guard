defmodule ExGuard.Notifier do
  def notify(opts) do
    ExGuard.Notifier.TerminalTitle.notify(opts)
  end
end
