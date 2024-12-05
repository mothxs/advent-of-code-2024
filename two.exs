defmodule Two do
  Code.require_file("inputs.exs")

  @spec safe_reports(boolean) :: :ok
  def safe_reports(dampened \\ false) do
    levels = Inputs.two()

    levels
    |> Enum.map(&normalize(&1))
    |> count_safe(dampened)
    |> IO.puts()
  end

  @spec count_safe(list, boolean, tuple, integer) :: integer
  defp count_safe(levels, _, dampening_process \\ {0, []}, total \\ 0)

  defp count_safe(levels, _, _, total) when levels == [], do: total

  defp count_safe([level | rest], dampened, {damp_index, original_list}, total) do
    {_, safe} =
      level
      |> Enum.with_index()
      |> Enum.reduce_while({nil, false}, fn {number, index}, acc ->
        check_safe(number, acc, Enum.at(level, index + 1))
      end)

    cond do
      !safe and dampened and damp_index <= length(level) ->
        original_list = if original_list == [], do: level, else: original_list
        levels = [List.delete_at(original_list, damp_index)] ++ rest
        count_safe(levels, dampened, {damp_index + 1, original_list}, total)

      !safe ->
        count_safe(rest, dampened, {0, []}, total)

      safe ->
        count_safe(rest, dampened, {0, []}, total + 1)
    end
  end

  @spec check_safe(integer, tuple, integer | nil) :: {:cont | :halt, tuple}
  defp check_safe(_, {_, false} = acc, nil), do: {:halt, acc}
  defp check_safe(_, acc, nil), do: {:cont, acc}

  defp check_safe(number, {nil, _}, next) do
    cond do
      number < next and (next - number >= 1 and next - number <= 3) ->
        {:cont, {:ascending, true}}

      number > next and (number - next >= 1 and number - next <= 3) ->
        {:cont, {:descending, true}}

      true ->
        {:halt, {nil, false}}
    end
  end

  defp check_safe(number, {:ascending = direction, _}, next)
       when number < next and (next - number >= 1 and next - number <= 3),
       do: {:cont, {direction, true}}

  defp check_safe(number, {:descending = direction, _}, next)
       when number > next and (number - next >= 1 and number - next <= 3),
       do: {:cont, {direction, true}}

  defp check_safe(_, {direction, _}, _), do: {:halt, {direction, false}}

  @spec normalize(binary) :: list
  defp normalize(numbers) do
    numbers |> String.split(" ") |> Enum.map(&String.to_integer(&1))
  end
end

Two.safe_reports()
Two.safe_reports(true)
