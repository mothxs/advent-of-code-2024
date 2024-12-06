defmodule Three do
  Code.require_file("inputs.exs")

  @regexp ~r/mul\(\d{1,3},\d{1,3}\)/
  @refined_regexp ~r/(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/

  def scan do
    input = Inputs.three()

    @regexp
    |> Regex.scan(input)
    |> Enum.flat_map(& &1)
    |> Enum.map(&(String.replace(&1, ["mul(", ")"], "") |> String.split(",") |> multiply()))
    |> Enum.sum()
    |> IO.puts()
  end

  def refined_scan do
    input = Inputs.three()

    @refined_regexp
    |> Regex.scan(input, capture: :first)
    |> Enum.flat_map(& &1)
    |> Enum.reduce({[], nil}, fn action, {valids, check} ->
      cond do
        action in ["do()", "don't()"] ->
          {valids, action}

        is_nil(check) ->
          {valids ++ [action], check}

        check == "do()" ->
          {valids ++ [action], check}

        check == "don't()" ->
          {valids, check}
      end
    end)
    |> elem(0)
    |> Enum.map(&(String.replace(&1, ["mul(", ")"], "") |> String.split(",") |> multiply()))
    |> Enum.sum()
    |> IO.puts()
  end

  defp multiply([first, second]) do
    String.to_integer(first) * String.to_integer(second)
  end
end

Three.scan()
Three.refined_scan()
