defmodule Mix.Tasks.Guard do
  @moduledoc """
  ExGuard automates various tasks by running custom rules whenever file or directories are modified.

  ## Usage
      usage: mix guard [--config=ExGuardfile]
      help: mix help guard

  ## Installation

  add `ex_guard` to `mix.exs`

      def deps do
        [{:ex_guard, "~> 0.0.4"}]
      end


  ## Sample config file

  Create ExGuardfile in your root mix directory:
      use ExGuard.Config

      guard("unit-test")
      |> command("mix test --color")
      |> watch(~r{\\.(erl|ex|exs|eex|xrl|yrl)\\z}i)
      |> ignore(~r/priv/)

  Run `mix guard` and happy coding.

  [Check out here for more fine-grained configs](https://hexdocs.pm/ex_guard/ExGuard.Guard.html).

  ## Notifications

  Notify the result of execution through:
    * [Terminal Title](http://tldp.org/HOWTO/Xterm-Title-3.html)
    * [Terminal Notifier](https://github.com/julienXX/terminal-notifier) (mac only)
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
