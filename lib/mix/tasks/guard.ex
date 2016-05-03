defmodule Mix.Tasks.Guard do
  @moduledoc """
  ExGuard automates various tasks by running custom rules whenever file or directories are modified.

  ## Usage
      usage: mix guard [--config=.exguard.exs]
      help: mix help guard

  ## Installation

  add `ex_guard` to `mix.exs`

      def deps do
        [{:ex_guard, "~> 1.0.0", only: :dev}]
      end


  ## Sample config file

  Create .exguard.exs in your root mix directory:
      use ExGuard.Config

      guard("unit-test")
      |> command("mix test --color")
      |> watch(~r{\\.(erl|ex|exs|eex|xrl|yrl)\\z}i)
      |> ignore(~r/priv/)

  Run `mix guard` and happy coding.

  [Check out here for more fine-grained configs](https://hexdocs.pm/ex_guard/ExGuard.Guard.html).

  ## Notifications

  Notify the result of execution through:
    * [Terminal Title](http://tldp.org/HOWTO/Xterm-Title-3.html) (Xterm)
    * [TMux](http://tmux.github.io/) (Universal)
    * [Terminal Notifier](https://github.com/julienXX/terminal-notifier) (mac only)
    * [Notify Send](http://ss64.com/bash/notify-send.html) (linux distros)
  """

  alias ExGuard.Config

  def run(args) do
    case OptionParser.parse(args) do
      {[config: config_file], _, _} -> execute(config_file)
      {[], [], []} -> execute(get_config_file)
      _ ->
        IO.puts "invalid option, try 'mix help guard'"
        System.halt(1)
    end
  end

  def execute(config_file) do
    Config.start_link
    ExGuard.start_link

    Config.load(config_file)

    Config.get_guards
    |> Enum.filter(fn(g) -> g.options[:run_on_start] end)
    |> ExGuard.execute_guards

    IO.puts "ExGuard is watching your back ..."
    :timer.sleep :infinity
  end

  defp get_config_file do
    case File.exists?("ExGuardfile") do
      true -> "ExGuardfile"
      _ -> ".exguard.exs"
    end
  end

end
