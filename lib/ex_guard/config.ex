defmodule ExGuard.Config do
  defmacro __using__(_options) do
    quote do
      import ExGuard.Guard
    end
  end

  def load(config_file) do
    Code.load_file(config_file)
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

  def match_guards(path) do
    Agent.get(__MODULE__,  fn kw ->
      kw
      |> Enum.map(&elem(&1, 1))
      |> Enum.map(fn (g) -> {g, first_matched_files(g, path)} end)
      |> Enum.filter(fn (t) -> elem(t, 1) != nil end)
    end)
  end

  defp first_matched_files(guard, path) do
    guard.watch
    |> Enum.filter(&eval_watch(&1, path))
    |> List.first
    |> execute_pattern(path)
  end

  defp eval_watch({pattern = %Regex{}, func}, path) when is_function(func) do
    eval_watch(pattern, path)
  end
  defp eval_watch(pattern = %Regex{}, path) do
    Regex.match?(pattern, path)
  end

  defp execute_pattern(nil, _path) do
    nil
  end
  defp execute_pattern(%Regex{}, _path) do
    []
  end
  defp execute_pattern({pattern = %Regex{}, func}, path) when is_function(func) do
    matched_name = Regex.named_captures(pattern, path)
    func.(matched_name)
    file_names = pattern
                  |> Regex.named_captures(path)
                  |> func.()
    List.flatten([file_names] ++ [])
  end
end
