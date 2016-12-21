defmodule ElixirWebFizzbuzz do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Fizzbuzz.Router, [], [port: 4001])
    ]

    opts = [strategy: :one_for_one, name: ElixirWebFizzbuzz.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
