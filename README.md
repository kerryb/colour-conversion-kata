# Colour Conversion

Create a function, that can convert RGB to HEX if the passed value is a struct,
or HEX to RGB if the value is a string.

```elixir
ColourConversion.convert("string") // will convert HEX to RGB.
ColourConversion.convert({r: 235, g: 64, b: 52}) //will convert RGB to HEX.
```

## Rules

If "R", "G" or "B" value is not between 0 and 255, return "Not valid input".

If the first character in the HEX string is a hash (#), then the string must
not have more than 7 characters, else if it doesn't have the hash, it must not
have more than 6 chraracters. If it isn't, return "Not valid input".

The output HEX value, must have this syntax: "#HEXVAL".

The output RGB value, must have this syntax (struct): %{r: NUM, g: NUM, b: NUM}

## Examples

```elixir
ColourConversion.convert("#ffffff") #=> %{r: 255, g: 255, b: 255}
ColourConversion.convert("#ff0025") #=> %{r: 255, g: 0, b: 37}
ColourConversion.convert(%{r: 40, g: 200, b: 125}) #=> "#28c87d"
```

## Notes

If the number in R, G or B is less than 10, the HEX code must have a "0" before
it; R, G and B values have to be numbers, not strings.

The HEX value (output) have to be lower case only (i.e. correct: #ffffff, wrong: #FFFFFF).

## Tests

```elixir
assert ColourConversion.convert(%{r: 126, g: 214, b: 131}) == '#7ed683'
assert ColourConversion.convert(%{r: 255, g: 255, b: 255}) == '#ffffff'

assert ColourConversion.convert(%{r: 0, g: 0, b: 0}) == '#000000'

assert ColourConversion.convert(%{r: 3, g: 1, b: 200}) == '#0301c8'
assert ColourConversion.convert(%{r: 85, g: 21, b: 180}) == '#5514b4'

assert ColourConversion.convert(%{r: 256, g: 0, b: 0}) == "Not valid input"
assert ColourConversion.convert(%{r: 0, g: 256, b: 0}) == "Not valid input"
assert ColourConversion.convert(%{r: 0, g: 0, b: 256}) == "Not valid input"

assert ColourConversion.convert(%{r: -1, g: 0, b: 0}) == "Not valid input"
assert ColourConversion.convert(%{r: 0, g: -1, b: 0}) == "Not valid input"
assert ColourConversion.convert(%{r: 0, g: 0, b: -1}) == "Not valid input"

assert ColourConversion.convert('fffffff') == "Not valid input"
assert ColourConversion.convert('#fffffff') == "Not valid input"
```
