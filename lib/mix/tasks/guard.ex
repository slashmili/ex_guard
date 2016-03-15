defmodule Mix.Tasks.Guard do

  def run(_args) do
    ExGuard.Config.start_link
    ExGuard.start_link
    ExGuard.Config.load
    :timer.sleep :infinity
  end
end
