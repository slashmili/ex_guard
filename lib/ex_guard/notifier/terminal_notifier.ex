defmodule ExGuard.Notifier.TerminalNotifier do
  @moduledoc false
  def notify(opts) do
    opts
    |> prepare_cmd
    |> Mix.Shell.IO.cmd
  end

  def prepare_cmd(opts) do
    "terminal-notifier -title \"#{opts[:title]}\" -message \"#{opts[:message]}\" -appIcon #{opts[:icon]} -contentImage #{opts[:content_image]}"
  end

  def available? do
    case System.cmd("which", ["terminal-notifier"]) do
      {_, 0} -> true
      {_, _} -> false
    end
  end
end
