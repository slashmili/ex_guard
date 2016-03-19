defmodule ExGuard.Config do
  @moduledoc """
  Holds the ExGuard configurations during run time.
  """

  defmacro __using__(_options) do
    quote do
      import ExGuard.Guard
    end
  end

  @doc """
  Loads ExGuard config file
  """
  def load(config_file) do
    Code.load_file(config_file)
  end

  @doc """
  Starts agent that keeps the configurations
  """
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc """
  Puts guard into agent
  """
  def put_guard(title, guard_struct) do
    Agent.update(__MODULE__, &Keyword.put(&1, String.to_atom(title), guard_struct))
    guard_struct
  end

  @doc """
  Returns agent based on guard title
  """
  def get_guard(title) do
    Agent.get(__MODULE__, &Keyword.get(&1, String.to_atom(title)))
  end

  def get_guards do
    Agent.get(__MODULE__, &Keyword.values(&1))
  end

  @doc """
  Given the path, returns matched guard configs.

  In case that a {regex, func} is given to watch, this function also executes
  the func and returns list of files
  """
  def match_guards(path) do
    Agent.get(__MODULE__,  fn kw ->
      kw
      |> Enum.map(&elem(&1, 1))
      |> Enum.filter(fn (g) -> path_ignored?(g, path) != true end)
      |> Enum.map(fn (g) -> {g, first_matched_files(g, path)} end)
      |> Enum.filter(fn (t) -> elem(t, 1) != nil end)
    end)
  end

  defp path_ignored?(guard, path) do
    path_match?(guard.ignore, path)
  end

  defp first_matched_files(guard, path) do
    guard.watch
    |> Enum.filter(&path_match?(&1, path))
    |> List.first
    |> execute_pattern(path)
  end

  defp path_match?({pattern = %Regex{}, func}, path) when is_function(func) do
    path_match?(pattern, path)
  end
  defp path_match?(pattern = %Regex{}, path) do
    Regex.match?(pattern, path)
  end
  defp path_match?(patterns, path) when is_list(patterns) do
    patterns
    |> Enum.map(&path_match?(&1, path))
    |> Enum.any?
  end
  defp path_match?(pattern, path) when is_binary(pattern) do
    String.contains?(pattern, path)
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
