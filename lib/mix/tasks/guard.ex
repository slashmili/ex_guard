defmodule Mix.Tasks.Guard do
  @moduledoc ~S"""
  ExGuard automates various tasks by running custom rules whenever file or directories are modified.

  ## Usage
      usage: mix guard [--config=.exguard.exs] [guard titles...]
      help: mix help guard

  ## Installation

  add `ex_guard` to `mix.exs`

      def deps do
        [{:ex_guard, "~> 1.1.1", only: :dev}]
      end


  ## Sample config file

  Create .exguard.exs in your root mix directory:
      use ExGuard.Config

      guard("unit-test")
      |> command("mix test --color")
      #config that match specific files:
      |> watch({~r{lib/(?<dir>.+)/(?<file>.+).ex$}, fn(m) -> "test/#{m["dir"]}/#{m["file"]}_test.exs" end})
      #if a file doesn't match with above pattern, this below pattern will be tested and applied
      |> watch(~r{\\.(erl|ex|exs|eex|xrl|yrl)\\z}i)
      |> ignore(~r/priv/)

  Run `mix guard` and happy coding.

  You can run `mix guard unit-test` to run the specific guard.

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
    case OptionParser.parse(args, switches: []) do
      {[config: config_file], guard_titles, []} ->
        execute(config_file, guard_titles)

      {[], guard_titles, []} ->
        execute(get_config_file(), guard_titles)

      _ ->
        IO.puts("invalid option, try 'mix help guard'")
        System.halt(1)
    end
  end

  defp execute(config_file, guard_titles) do
    Config.start_link()
    ExGuard.start_link()

    Config.load(config_file)
    Config.get_guards()
    |> Enum.reject(fn g ->
      with false <- Enum.empty?(guard_titles),
           false <- Enum.any?(guard_titles, &(&1 == g.title)) do
        Config.remove_guard(g.title)
        true
      else
        _ -> false
      end
    end)
    |> Enum.filter(fn g -> g.options[:run_on_start] end)
    |> ExGuard.execute_guards()

    Mix.Shell.IO.info("ExGuard is watching your back ...")
    :timer.sleep(:infinity)
  end

  defp get_config_file do
    case File.exists?("ExGuardfile") do
      true -> "ExGuardfile"
      _ -> ".exguard.exs"
    end
  end
end
