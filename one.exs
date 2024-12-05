defmodule One do
  Code.require_file("inputs.exs")

  @spec distance :: :ok
  def distance() do
    {first, second} = Inputs.one()
    first = Enum.sort(first)
    second = Enum.sort(second)

    first
    |> Enum.zip(second)
    |> Enum.into(%{})
    |> Enum.reduce([], fn {num1, num2}, acc ->
      acc ++ [abs(num1 - num2)]
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  @spec similarity :: :ok
  def similarity() do
    {first, second} = Inputs.one()

    Enum.reduce(first, [], fn number, acc -> 
      acc ++ [number * Enum.count(second, & &1 == number)]
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

One.distance()
One.similarity()

