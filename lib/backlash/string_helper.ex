defmodule Backlash.StringHelper do
  @spec reduce(list, 1) :: String.t
  defp reduce([head | []], 1) do
    head
  end
  @spec reduce(list, 1) :: String.t
  defp reduce([head | _], 1) do
    head <> "..."
  end
  @spec reduce([], number) :: String.t
  defp reduce([], _) do
    ""
  end
  @spec reduce(list, number) :: String.t
  defp reduce(word, length) when is_list(word) do
    [head | tail] = word
    head <> reduce(tail, length-1)
  end

  @spec truncate(String.t, number) :: String.t
  def truncate(word, length) do
    reduce(String.codepoints(word), length)
  end
end
