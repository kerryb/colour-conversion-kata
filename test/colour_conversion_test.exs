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
  end
end
