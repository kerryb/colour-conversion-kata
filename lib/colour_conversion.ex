defmodule ColourConversion do
  use Bitwise

  @error_response "Not valid input"

  def convert(%{r: r, g: g, b: b})
      when r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 do
    hex =
      ((r <<< 16) + (g <<< 8) + b)
      |> Integer.to_string(16)
      |> String.downcase()
      |> String.pad_leading(6, "0")

    "##{hex}"
  end

  def convert(<<"#", hex::binary>>), do: convert(hex)

  def convert(<<r::binary-size(1), g::binary-size(1), b::binary-size(1)>>) do
    convert("#{r}#{r}#{g}#{g}#{b}#{b}")
  end

  def convert(<<r::binary-size(2), g::binary-size(2), b::binary-size(2)>>) do
    if "#{r}#{g}#{b}" =~ ~r/^[\da-f]*$/ do
      %{r: String.to_integer(r, 16), g: String.to_integer(g, 16), b: String.to_integer(b, 16)}
    else
      @error_response
    end
  end

  def convert(_), do: @error_response
end
