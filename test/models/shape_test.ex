defmodule BdRt.ShapeTest do
  use BdRt.ModelCase

  alias BdRt.Shape
  alias BdRt.ShapePoint

  test 'coordinates returns an array of latitude, longitude  doubles' do
    shape_point2 = %ShapePoint { latitude: 2.1, longitude: 2.2, sequence: 2 }
    shape_point1 = %ShapePoint { latitude: 1.1, longitude: 1.2, sequence: 1 }
    shape = %Shape { shape_points: [shape_point1, shape_point2] }
    assert Shape.coordinates(shape) == [[1.1, 1.2], [2.1, 2.2]]
  end
end
