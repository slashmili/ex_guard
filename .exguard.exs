use ExGuard.Config

guard("unit-test", run_on_start: true)
|> command("mix test --color")
#config that match specific files:
|> watch({~r{lib/(?<dir>.+)/(?<file>.+).ex$}, fn(m) -> "test/#{m["dir"]}/#{m["file"]}_test.exs" end})
#if a file doesn't match with the above pattern, the below pattern will be tested and applied
|> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
