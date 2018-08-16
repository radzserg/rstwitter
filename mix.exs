defmodule RsTwitter.MixProject do
  use Mix.Project

  def project do
    [
      app: :rs_twitter,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      description: "Twitter Client",
      package: package(),
      source_url: "https://github.com/radzserg/rstwitter",

      # meta data for docs
      name: "RsTwitter",
      source_url: "https://github.com/radzserg/rstwitter",
      # homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [
        main: "RsTwitter", # The main page in the docs
        #logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Sergey Radzishevskyi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/radzserg/rstwitter"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:oauther, "~> 1.1"},
      {:mox, "~> 0.4", only: :test},
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
    ]
  end
end
