defmodule ColourConversion do
  use Bitwise

  def convert(%{r: r, g: g, b: b})
      when r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 do
    "##{((r <<< 16) + (g <<< 8) + b) |> Integer.to_string(16) |> String.pad_leading(6, "0")}"
  end

  def convert(<<"#", hex::binary>>), do: convert(hex)

  def convert(<<r::binary-size(2), g::binary-size(2), b::binary-size(2)>>) do
    %{r: String.to_integer(r, 16), g: String.to_integer(g, 16), b: String.to_integer(b, 16)}
  end

  def convert(_), do: "Not valid input"
end
