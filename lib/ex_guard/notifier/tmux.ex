defmodule ExGuard.Notifier.TMux do
  @moduledoc false
  def notify(opts) do
    opts
    |> prepare_cmd
    |> Mix.Shell.IO.cmd()
  end

  def prepare_cmd(opts) do
    "tmux set -q status-left-bg #{get_color(opts[:status])}"
  end

  def available? do
    System.get_env("TMUX") != nil
  end

  defp get_color(:ok), do: "green"
  defp get_color(:error), do: "red"
  defp get_color(:pending), do: "yellow"
end
