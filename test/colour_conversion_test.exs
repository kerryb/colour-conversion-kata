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

    property "converts hex (with a leading hash) to rgb" do
      forall {r, g, b} <- {byte(), byte(), byte()} do
        hex = "##{to_hex(r)}#{to_hex(g)}#{to_hex(b)}"
        rgb = %{r: r, g: g, b: b}
        assert convert(hex) == rgb
      end
    end

    property "converts hex (without a leading hash) to rgb" do
      forall {r, g, b} <- {byte(), byte(), byte()} do
        hex = "#{to_hex(r)}#{to_hex(g)}#{to_hex(b)}"
        rgb = %{r: r, g: g, b: b}
        assert convert(hex) == rgb
      end
    end

    property "supports three-character hex codes" do
      forall {r, g, b} <- {integer(0, 15), integer(0, 15), integer(0, 15)} do
        hex = "#{unpadded_hex(r)}#{unpadded_hex(g)}#{unpadded_hex(b)}"
        rgb = %{r: r * 17, g: g * 17, b: b * 17}
        assert convert(hex) == rgb
      end
    end

    property "returns an error message for invalid red values" do
      forall {r, g, b} <- {non_byte_integer(), byte(), byte()} do
        rgb = %{r: r, g: g, b: b}
        assert convert(rgb) == "Not valid input"
      end
    end

    property "returns an error message for invalid green values" do
      forall {r, g, b} <- {byte(), non_byte_integer(), byte()} do
        rgb = %{r: r, g: g, b: b}
        assert convert(rgb) == "Not valid input"
      end
    end

    property "returns an error message for invalid blue values" do
      forall {r, g, b} <- {byte(), byte(), non_byte_integer()} do
        rgb = %{r: r, g: g, b: b}
        assert convert(rgb) == "Not valid input"
      end
    end

    property "returns an error message for hex strings (with a leading hash) that are longer than six characters" do
      forall hex <- hex_string(7, :inf) do
        assert convert("##{hex}") == "Not valid input"
      end
    end

    property "returns an error message for hex strings(with a leading hash) that are shorter than three characters" do
      forall hex <- hex_string(0, 2) do
        assert convert("##{hex}") == "Not valid input"
      end
    end

    property "returns an error message for hex strings(with a leading hash) that are four or five characters long" do
      forall hex <- hex_string(4, 5) do
        assert convert("##{hex}") == "Not valid input"
      end
    end

    property "returns an error message for hex strings (without a leading hash) that are longer than six characters" do
      forall hex <- hex_string(7, :inf) do
        assert convert(hex) == "Not valid input"
      end
    end

    property "returns an error message for hex strings(without a leading hash) that are shorter than three characters" do
      forall hex <- hex_string(0, 2) do
        assert convert(hex) == "Not valid input"
      end
    end

    property "returns an error message for hex strings(without a leading hash) that are four or five characters long" do
      forall hex <- hex_string(4, 5) do
        assert convert(hex) == "Not valid input"
      end
    end

    property "returns an error message for non-hex strings" do
      forall not_hex <- non_hex_string() do
        assert convert(not_hex) == "Not valid input"
      end
    end
  end

  defp non_byte_integer do
    oneof([integer(:inf, -1), integer(256, :inf)])
  end

  defp hex_string(min_length, max_length) do
    let length <- integer(min_length, max_length) do
      let chars <- vector(length, hex_char()) do
        Enum.join(chars)
      end
    end
  end

  defp hex_char do
    oneof(~w(0 1 2 3 4 5 6 7 8 9 a b c d e f))
  end

  defp non_hex_string do
    such_that(str <- binary(6), when: not (str =~ ~r/^[^\da-f]*$/))
  end

  defp unpadded_hex(integer) do
    integer
    |> Integer.to_string(16)
    |> String.downcase()
  end

  defp to_hex(integer) do
    integer
    |> unpadded_hex()
    |> String.pad_leading(2, "0")
  end
end
