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
    available = case System.cmd("which", ["terminal-notifier"], stderr_to_stdout: true) do
      {_, 0} -> true
      {_, _} -> false
    end
    available && System.get_env("TMUX") == nil
  end
end
