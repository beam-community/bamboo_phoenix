# Bamboo.Phoenix [![Circle CI](https://circleci.com/gh/thoughtbot/bamboo_phoenix/tree/main.svg?style=svg)](https://circleci.com/gh/thoughtbot/bamboo_phoenix/tree/main)

**Bamboo & Bamboo.Phoenix are part of the [thoughtbot Elixir family][elixir-phoenix] of projects.**

`Bamboo.Phoenix` is a library to use Phoenix's View rendering layer for your
[Bamboo] emails. After installation, see the [Bamboo.Phoenix docs] for more information.

[Bamboo]: https://github.com/thoughtbot/bamboo
[Bamboo.Phoenix docs]: https://hexdocs.pm/bamboo_phoenix/Bamboo.Phoenix.html

## Installation

Make sure you have `Bamboo` installed. To install `Bamboo.Phoenix`, add it to
your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bamboo_phoenix, "~> 1.0.0"}
  ]
end
```

## Contributing

Before opening a pull request, please open an issue first.

Once we've decided how to move forward with a pull request:

    $ git clone https://github.com/thoughtbot/bamboo_phoenix.git
    $ cd bamboo_phoenix
    $ mix deps.get
    $ mix test
    $ mix format

Once you've made your additions and `mix test` passes, go ahead and open a PR!

We run the test suite as well as formatter checks on CI. Make sure you are using
the Elixir version defined in the `.tool-versions` file to have consistent
formatting with what's being run on CI.

## About thoughtbot

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

Bamboo & Bamboo.Phoenix area maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open-source software, Elixir, and Phoenix. See [our other Elixir
projects][elixir-phoenix], or [hire our Elixir Phoenix development team][hire]
to design, develop, and grow your product.

[elixir-phoenix]: https://thoughtbot.com/services/elixir-phoenix?utm_source=github
[hire]: https://thoughtbot.com?utm_source=github
