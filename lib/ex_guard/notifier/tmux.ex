defmodule ExGuard.Notifier.TMux do
  @moduledoc false
  def notify(opts) do
    opts
    |> prepare_cmd
    |> Mix.Shell.IO.cmd()
  end

  def prepare_cmd(opts) do
    title = opts[:title] || "ExGuard"
    message = opts[:message]
    status = opts[:status]
    color = status |> get_color()
    "tmux display-message '#[fill=#{color} bg=#{color}]#{title} - #{message}'; tmux set -g pane-active-border fg=#{color}"
  end

  def available? do
    System.get_env("TMUX") != nil
  end

  defp get_color(:ok), do: "green"
  defp get_color(:error), do: "red"
  defp get_color(:pending), do: "yellow"
end
