defmodule ColourConversion do
  use Bitwise

  def convert(%{r: r, g: g, b: b}) do
    "##{((r <<< 16) + (g <<< 8) + b) |> Integer.to_string(16) |> String.pad_leading(6, "0")}"
  end

  def convert(<<"#", r::binary-size(2), g::binary-size(2), b::binary-size(2)>>) do
    %{r: String.to_integer(r, 16), g: String.to_integer(g, 16),  b: String.to_integer(b, 16)}
  end
end
