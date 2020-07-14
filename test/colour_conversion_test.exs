defmodule ColourConversionTest do
  use ExUnit.Case
  use PropCheck

  import ColourConversion

  describe "ColourConversion.convert/1" do
    property "is self-inverse" do
      forall {r, g, b} <- {byte(), byte(), byte()} do
        rgb = %{r: r, g: g, b: b}
        assert rgb |> convert() |> convert() == rgb
      end
    end

    property "converts rgb to hex" do
      forall {r, g, b} <- {byte(), byte(), byte()} do
        rgb = %{r: r, g: g, b: b}
        hex = "##{to_hex(r)}#{to_hex(g)}#{to_hex(b)}"
        assert convert(rgb) == hex
      end
    end

    property "converts hex to rgb" do
      forall {r, g, b} <- {byte(), byte(), byte()} do
        hex = "##{to_hex(r)}#{to_hex(g)}#{to_hex(b)}"
        rgb = %{r: r, g: g, b: b}
        assert convert(hex) == rgb
      end
    end
  end

  defp to_hex(integer) do
    integer
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end
end
