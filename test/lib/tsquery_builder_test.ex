defmodule BdRt.TsqueryBuilderTest do
  use ExUnit.Case, async: true
  alias BdRt.TsqueryBuilder

  test 'a single value is simple' do
    assert TsqueryBuilder.build("Main") == "(main)"
  end

  test 'values separated by and are separated' do
    assert TsqueryBuilder.build("Main and Bar") == "(main) & (bar)"
  end

  test 'multiple values are anded together' do
    assert TsqueryBuilder.build("Main Bar") == "(main & bar)"
  end

  test 'provides substitutions' do
    assert TsqueryBuilder.build("Main St and Twelfth Ave") == "(main & (street | st | str)) & ((12 | twelfth | 12th) & (avenue | ave))"
  end

  test 'does not mess up words with and in it' do
    assert TsqueryBuilder.build("Highland & University") == "(highland) & (university)"
  end

  test 'escapes the values' do
    assert TsqueryBuilder.build("Highland's & University") == "(highland's) & (university)"
  end
end

