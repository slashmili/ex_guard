defmodule ExGuard.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :ex_guard,
     version: @version,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,

     name: "ExGuard",
     docs: [source_ref: "#{@version}", main: "Mix.Tasks.Guard", logo: "logo-white.png"],
     source_url: "https://github.com/slashmili/ex_guard",]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:fs, "~> 0.9"},
     {:ex_doc, "~> 0.11.4", only: :dev},
     {:earmark, "~> 0.2.1", only: :dev}]
  end
end
