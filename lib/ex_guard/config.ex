defmodule ExGuard.Config do
  defmacro __using__(_options) do
    quote do
      import ExGuard.Guard
    end
  end

  def load do
    Code.load_file("ExGuardfile")
  end

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def put_guard(title, guard_struct) do
    Agent.update(__MODULE__, &Keyword.put(&1, String.to_atom(title), guard_struct))
    guard_struct
  end

  def get_guard(title) do
    Agent.get(__MODULE__,  &Keyword.get(&1, String.to_atom(title)))
  end
end
