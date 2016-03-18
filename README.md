# ExGuard

![ExGuard](https://github.com/slashmili/ex_guard/raw/master/logo.png)


[![Build Status](https://travis-ci.org/slashmili/ex_guard.svg?branch=master)](https://travis-ci.org/slashmili/ex_guard)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_guard.svg)](https://hex.pm/packages/ex_guard)
[![Docs](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat)](http://slashmili.github.io/ex_guard)
[![Hex.pm](https://img.shields.io/hexpm/dt/ex_guard.svg)](https://hex.pm/packages/ex_guard)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/slashmili/ex_guard.svg)](https://beta.hexfaktor.org/github/slashmili/ex_guard)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_guard.svg)]()


**NOTE: This module is experimental!**

## Installation

  1. Add ex_guard to your list of dependencies in `mix.exs`:

        def deps do
          [{:ex_guard, git: "https://github.com/slashmili/ex_guard.git", only: :dev}]
        end

  2. Create a file named `ExGuardfile` in your root directory:
    ```elixir
      use ExGuard.Config

      guard("unit-test")
      |> command("mix test --color")
      |> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
    ```
  3. run `mix guard` as soon as you change any file with above pattern, the test gets executed

