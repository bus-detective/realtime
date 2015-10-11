defmodule BdRt.Ordinalize do

  @cache ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
           "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty",
           "twenty-one", "twenty-two", "twenty-three", "twenty-four", "twenty-five", "twenty-six", "twenty-seven", "twenty-eight", "twenty-nine",
           "thirty", "thirty-one", "thirty-two", "thirty-three", "thirty-four", "thirty-five", "thirty-six", "thirty-seven", "thirty-eight", "thirty-nine",
           "forty", "forty-one", "forty-two", "forty-three", "forty-four", "forty-five", "forty-six", "forty-seven", "forty-eight", "forty-nine",
           "fifty", "fifty-one", "fifty-two", "fifty-three", "fifty-four", "fifty-five", "fifty-six", "fifty-seven", "fifty-eight", "fifty-nine",
           "sixty", "sixty-one", "sixty-two", "sixty-three", "sixty-four", "sixty-five", "sixty-six", "sixty-seven", "sixty-eight", "sixty-nine",
           "seventy", "seventy-one", "seventy-two", "seventy-three", "seventy-four", "seventy-five", "seventy-six", "seventy-seven", "seventy-eight", "seventy-nine",
           "eighty", "eighty-one", "eighty-two", "eighty-three", "eighty-four", "eighty-five", "eighty-six", "eighty-seven", "eighty-eight", "eighty-nine",
           "ninety", "ninety-one", "ninety-two", "ninety-three", "ninety-four", "ninety-five", "ninety-six", "ninety-seven", "ninety-eight", "ninety-nine",
  ]

  @conversions %{
    "one" => "first",
    "two" => "second",
    "three" => "third",
    "four" => "fourth",
    "five" => "fifth",
    "six" => "sixth",
    "seven" => "seventh",
    "eight" => "eighth",
    "nine" => "ninth",
    "ten" => "tenth",
    "eleven" => "eleventh",
    "twelve" => "twelfth",
  }

  def ordinalize(number) do
    "#{number}#{ordinal(number)}"
  end

  def ordinal(number) do
    abs_number = abs(number)

    if Enum.member?(11..13, rem(abs_number, 100)) do
      "th"
    else
      case rem(abs_number, 10) do
        1 -> "st"
        2 -> "nd"
        3 -> "rd"
        _ -> "th"
      end
    end
  end

  def englishize(i) do
    humanized = Enum.at(@cache, i)
    # 13-19
    humanized = String.replace(humanized, ~r{teen$}, "th")
    # 20, 30, 40, etc.
    humanized = String.replace(humanized, ~r{ty$}, "tieth")

    cond do
      Dict.has_key?(@conversions, humanized) -> Dict.get(@conversions, humanized)
      split_dashes(humanized) != "" -> split_dashes(humanized) # Handles things like fourty-three to fourty-third
      split_spaces(humanized) != "" -> split_spaces(humanized) # Handles one hundred and above
      true -> humanized
    end
  end

  defp split_dashes(humanize) do
    parts = String.split(humanize, "-")
    List.replace_at(parts, -1, Dict.get(@conversions, List.last(parts)))
    |> Enum.join("-")
  end

  defp split_spaces(humanize) do
    parts = String.split(humanize)
    List.replace_at(parts, -1, Dict.get(@conversions, List.last(parts)))
    |> Enum.join("-")
  end
end

