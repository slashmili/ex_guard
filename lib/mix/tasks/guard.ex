defmodule Mix.Tasks.Guard do
  @moduledoc """
  ExGuard automates various tasks by running custom rules whenever file or directories are modified.
  """

  def run(args) do
    case OptionParser.parse(args) do
      {[config: config_file], _, _ } -> execute(config_file)
      {[], [], []} -> execute("ExGuardfile")
      _ ->
        IO.puts "invalid option, try 'mix help guard'"
        System.halt(1)
    end
  end

  def execute(config_file) do
    ExGuard.Config.start_link
    ExGuard.start_link
    ExGuard.Config.load(config_file)
    :timer.sleep :infinity
  end
end
