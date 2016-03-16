defmodule ExGuard.Notifier do
  @notifiers [
    ExGuard.Notifier.TerminalTitle,
    ExGuard.Notifier.TerminalNotifier
  ]

  def notify(opts) do
    opts = opts
      |> Keyword.put(:content_image, content_image(opts[:status]))
      |> Keyword.put(:icon, get_icon)

    @notifiers
    |> Enum.filter(fn (n) -> apply(n, :available?, []) end)
    |> Enum.each(fn (n) -> apply(n, :notify, [opts]) end)
    :ok
  end

  defp content_image(status) do
    case status do
      :ok -> "priv/icons/Success.icns"
      :error -> "priv/icons/Failed.icns"
      :pending -> "priv/icons/Failed.icns"
      _ -> ""
    end
  end

  defp get_icon do
    "priv/icons/Guard.icns"
  end
end
