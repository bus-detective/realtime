defmodule BdRt.OrdinalizeTest do
  use ExUnit.Case, async: true
  alias BdRt.Ordinalize

  test 'englishize simple numbers' do
    assert Ordinalize.englishize(1) == "first"
    assert Ordinalize.englishize(8) == "eighth"
  end

  test 'englishize teen numbers' do
    assert Ordinalize.englishize(12) == "twelfth"
    assert Ordinalize.englishize(18) == "eighteenth"
  end

  test 'englishize big numbers' do
    assert Ordinalize.englishize(99) == "ninety-ninth"
  end

  test 'ordinalizes simple numbers' do
    assert Ordinalize.ordinalize(1) == "1st"
    assert Ordinalize.ordinalize(8) == "8th"
  end

  test 'ordinalizes teen numbers' do
    assert Ordinalize.ordinalize(12) == "12th"
    assert Ordinalize.ordinalize(18) == "18th"
  end

  test 'ordinalizes big numbers' do
    assert Ordinalize.ordinalize(114) == "114th"
  end
end

