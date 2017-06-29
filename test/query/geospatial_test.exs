defmodule GeospatialTest do
  use ExUnit.Case, async: true
  use RethinkDB.Connection
  import RethinkDB.Query

  alias RethinkDB.Record
  alias RethinkDB.Pseudotypes.Geometry.Point
  alias RethinkDB.Pseudotypes.Geometry.Line
  alias RethinkDB.Pseudotypes.Geometry.Polygon

  setup_all do
    start_link()
    :ok
  end

  test "circle" do
<<<<<<< HEAD
<<<<<<< HEAD
    {:ok, %Record{data: data}} = circle({1,1}, 5) |> run
    assert %Polygon{coordinates: [_h | []]} = data
  end

  test "circle with opts" do
    {:ok, %Record{data: data}} = circle({1,1}, 5, num_vertices: 100, fill: true) |> run
    assert %Polygon{coordinates: [_h |[]]} = data
=======
    %Record{data: data} = circle({1,1}, 5) |> run
=======
    %Record{data: data} = circle({1,1}, 5) |> run
    assert %Polygon{outer_coordinates: [_h | _t], inner_coordinates: []} = data
  end

  test "circle with opts" do
    %Record{data: data} = circle({1,1}, 5, num_vertices: 100, fill: true) |> run
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
    assert %Polygon{outer_coordinates: [_h | _t], inner_coordinates: []} = data
  end

  test "circle with opts" do
    %Record{data: data} = circle({1,1}, 5, num_vertices: 100, fill: true) |> run
    assert %Polygon{outer_coordinates: [_h | _t], inner_coordinates: []} = data
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
  end
  test "distance" do
    %Record{data: data} = distance(point({1,1}), point({2,2})) |> run
    assert data == 156876.14940188665
  end

  test "fill" do
<<<<<<< HEAD
<<<<<<< HEAD
    {:ok, %Record{data: data}} = fill(line([{1,1}, {4,5}, {2,2}, {1,1}])) |> run
    assert data == %Polygon{coordinates: [[{1,1}, {4,5}, {2,2}, {1,1}]]}
=======
=======
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
    %Record{data: data} = fill(line([{1,1}, {4,5}, {2,2}, {1,1}])) |> run
    assert data == %Polygon{outer_coordinates: [{1,1}, {4,5}, {2,2}, {1,1}]}
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
  end

  test "geojson" do
    %Record{data: data} = geojson(%{coordinates: [1,1], type: "Point"}) |> run
    assert data == %Point{coordinates: {1,1}}
  end

  test "geojson with holes" do
    coords = [ square(0,0,10), square(1,1,1), square(4,4,1) ]
    {:ok, %Record{data: data}} = geojson(%{type: "Polygon", coordinates: coords}) |> run
    assert data == %Polygon{coordinates: coords}
  end

  defp square(x,y,s) do
    [{x,y}, {x+s,y}, {x+s,y+s}, {x,y+s}, {x,y}]
  end

  test "to_geojson" do
    %Record{data: data} = point({1,1}) |> to_geojson |> run
    assert data == %{"type" => "Point", "coordinates" => [1,1]}
  end

  # TODO: get_intersecting, get_nearest, includes, intersects
  test "point" do
    %Record{data: data} = point({1,1}) |> run
    assert data == %Point{coordinates: {1, 1}}
  end

  test "line" do
    %Record{data: data} = line([{1,1}, {4,5}]) |> run
    assert data == %Line{coordinates: [{1, 1}, {4,5}]}
  end


  test "includes" do
    %Record{data: data} = [circle({0,0}, 1000), circle({0.001,0}, 1000), circle({100,100}, 1)] |> includes(
        point(0,0)
      ) |> run
    assert Enum.count(data) == 2
    %Record{data: data} = circle({0,0}, 1000) |> includes(point(0,0)) |> run
    assert data == true
    %Record{data: data} = circle({0,0}, 1000) |> includes(point(80,80)) |> run
    assert data == false
  end

  test "intersects" do
    b = [
        circle({0,0}, 1000), circle({0,0}, 1000), circle({80,80}, 1)
      ] |> intersects(
        circle({0,0}, 10)
      )
    %Record{data: data} = b |> run
    assert Enum.count(data) == 2
    %Record{data: data} = circle({0,0}, 1000) |> intersects(circle({0,0}, 1)) |> run
    assert data == true
    %Record{data: data} = circle({0,0}, 1000) |> intersects(circle({80,80}, 1)) |> run
    assert data == false
  end

  test "polygon" do
<<<<<<< HEAD
<<<<<<< HEAD
    {:ok, %Record{data: data}} = polygon([{0,0}, {0,1}, {1,1}, {1,0}]) |> run
    assert data.coordinates == [[{0,0}, {0,1}, {1,1}, {1,0}, {0,0}]]
=======
=======
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
    %Record{data: data} = polygon([{0,0}, {0,1}, {1,1}, {1,0}]) |> run
    assert data.outer_coordinates == [{0,0}, {0,1}, {1,1}, {1,0}, {0,0}]
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
  end

  test "polygon_sub" do
    p1 = polygon([{0,0}, {0,1}, {1,1}, {1,0}])
    p2 = polygon([{0.25,0.25}, {0.25,0.5}, {0.5,0.5}, {0.5,0.25}])
<<<<<<< HEAD
<<<<<<< HEAD
    {:ok, %Record{data: data}} = p1 |> polygon_sub(p2) |> run
    assert data.coordinates == [[{0,0}, {0,1}, {1,1}, {1,0}, {0,0}], [{0.25,0.25}, {0.25,0.5}, {0.5,0.5}, {0.5,0.25}, {0.25,0.25}]]
=======
=======
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
    %Record{data: data} = p1 |> polygon_sub(p2) |> run
    assert data.outer_coordinates == [{0,0}, {0,1}, {1,1}, {1,0}, {0,0}]
    assert data.inner_coordinates == [{0.25,0.25}, {0.25,0.5}, {0.5,0.5}, {0.5,0.25}, {0.25,0.25}]
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
  end
end
