defmodule ExGuard.Notifier.TerminalTitle do
  @moduledoc false

  def notify(opts) do
    IO.puts :stderr, "\e]2;[#{opts[:title]}] #{opts[:message]} \a"
  end


  def available?, do: true
end
