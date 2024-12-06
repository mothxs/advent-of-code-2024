defmodule Three do
  Code.require_file("inputs.exs")
  @regexp ~r/mul\(\d{1,3},\d{1,3}\)/

  def scan do
    input = Inputs.three()

    result =
      @regexp
      |> Regex.scan(input)
      |> Enum.flat_map(& &1)
      |> Enum.map(&(String.replace(&1, ["mul(", ")"], "") |> String.split(",") |> multiply()))
      |> Enum.sum()

    IO.puts(result)
  end

  defp multiply([first, second]) do
    String.to_integer(first) * String.to_integer(second)
  end
end

Three.scan()
