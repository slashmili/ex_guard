defmodule ExGuard.Mixfile do
  use Mix.Project

  @version "1.5.0"

  def project do
    [
      app: :ex_guard,
      version: @version,
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "ExGuard",
      docs: [source_ref: "#{@version}", main: "Mix.Tasks.Guard", logo: "logo-white.png"],
      source_url: "https://github.com/slashmili/ex_guard"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:fs, "~> 6.9"},
      {:ex_doc, "~> 0.25.2", only: :dev},
      {:earmark, "~> 1.4.12", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Milad Rastian"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/slashmili/ex_guard"},
      files: ~w(lib priv LICENSE mix.exs logo-white.png) ++ ~w(mix.exs README.md)
    ]
  end

  defp description do
    """
    ExGuard automates various tasks by running custom rules whenever file or directories are modified.
    """
  end
end
