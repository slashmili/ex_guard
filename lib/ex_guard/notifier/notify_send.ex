defmodule ExGuard.Notifier.NotifySend do
  @moduledoc false
  def notify(opts) do
    opts
    |> prepare_cmd
    |> Mix.Shell.IO.cmd()
  end

  def prepare_cmd(opts) do
    ~s(notify-send --app-name=ExGuard --icon="#{opts[:icon]}" "#{opts[:title]}" "#{opts[:message]}")
  end

  def available? do
    case System.cmd("which", ["notify-send"], stderr_to_stdout: true) do
      {_, 0} -> true
      {_, _} -> false
    end
  end
end
