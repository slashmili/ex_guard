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

  1. Add ex_guard to your list of dependencies in `mix.exs`:

        def deps do
          [{:ex_guard, "~> 0.9.0", only: :dev}]
        end

  2. Create a file named `ExGuardfile` in your root application directory:
    ```elixir
      use ExGuard.Config

      guard("unit-test")
      |> command("mix test --color")
      |> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
    ```
    Look at [ExGuardfile](https://github.com/slashmili/ex_guard/blob/master/ExGuardfile) for more fine-grained config
  3. run `mix guard` as soon as you change any file with above pattern, the test gets executed

  

