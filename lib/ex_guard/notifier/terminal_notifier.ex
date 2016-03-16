defmodule ExGuard.Notifier.TerminalNotifier do
  def notify(opts) do
    opts
    |> prepare_cmd
    |> Mix.Shell.IO.cmd
  end

  def prepare_cmd(opts) do
    "terminal-notifier -title #{opts[:title]} -message #{opts[:message]} -appIcon #{opts[:icon]} -contentImage #{opts[:content_image]}"
  end

  def available? do
    case Mix.Shell.IO.cmd("which terminal-notifier") do
      0 -> true
      _ -> false
    end
  end
end
