# ExGuard

ExGuard is a mix command to handle events on file system modifications, ExGuard heavily borrowed ideas/art works from [Guard](https://github.com/guard/guard)

![ExGuard](https://github.com/slashmili/ex_guard/raw/master/logo.png)


[![Build Status](https://travis-ci.org/slashmili/ex_guard.svg?branch=master)](https://travis-ci.org/slashmili/ex_guard)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_guard.svg)](https://hex.pm/packages/ex_guard)
[![Docs](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat)](https://hexdocs.pm/ex_guard/)
[![Hex.pm](https://img.shields.io/hexpm/dt/ex_guard.svg)](https://hex.pm/packages/ex_guard)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/slashmili/ex_guard.svg)](https://beta.hexfaktor.org/github/slashmili/ex_guard)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_guard.svg)]()


## Usage

1. Add `ex_guard` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_guard, "~> 1.3", only: :dev}]
    end
    ```

2. Create a file named `.exguard.exs` in your root application directory:

    ```elixir
    use ExGuard.Config

    guard("unit-test")
    |> command("mix test --color")
    |> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
    |> ignore(~r{deps})
    |> notification(:auto)
    ```

    Look at [.exguard.exs](https://github.com/slashmili/ex_guard/blob/master/.exguard.exs) for more fine-grained config.

3. Run `mix guard` as soon as you change any file with above pattern, the test gets executed

## Notification

Currently supports notification with tools:

* [Terminal Title](http://tldp.org/HOWTO/Xterm-Title-3.html) (Xterm)
* [TMux](http://tmux.github.io/) (Universal)
* [Terminal Notifier](https://github.com/julienXX/terminal-notifier) (mac only)
* [Notify Send](http://ss64.com/bash/notify-send.html) (linux distros)

In order to _ExGuard_ sends notification, you need to make sure these tools are setup properly.

If you are using _ExGuard_ mainly for Elixir test you may turn the notification off and use [ExUnit Notifier](https://github.com/navinpeiris/ex_unit_notifier) instead.

## Why ExGuard and not mix-test.watch or eye_drops or XYZ

It's just a matter of taste!

With _ExGuard_ you can run multiple commands and the config looks nice.

```elixir
use ExGuard.Config

guard("elixir test", run_on_start: true)
|> command("mix test --color")
|> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
|> ignore(~r{deps})
|> notification(:off)

guard("elm test", run_on_start: true)
|> command("elm-test assets/tests/")
|> watch(~r{\.(elm)\z}i)
|> ignore(~r{elm-stuff})
|> notification(:auto)
```
