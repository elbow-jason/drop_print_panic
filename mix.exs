defmodule DropPrintPanic.MixProject do
  use Mix.Project

  def project do
    [
      app: :drop_print_panic,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: [
        dropprintpanic_native: [
          mode: rustc_mode(Mix.env())
        ]
      ],
    ]
  end

  def rustc_mode(:prod), do: :release
  def rustc_mode(:test), do: :debug
  def rustc_mode(:dev), do: :debug
  def rustc_mode(_), do: :release


  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.21.0"}
    ]
  end
end
