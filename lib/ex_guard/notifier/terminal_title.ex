defmodule ExGuard.Notifier.TerminalTitle do
  def notify(opts) do
    IO.puts :stderr, "\e]2;[#{opts[:title]}] #{opts[:message]} \a"
  end


  def available?, do: true
end
