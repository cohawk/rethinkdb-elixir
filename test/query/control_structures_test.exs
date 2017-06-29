defmodule ControlStructuresTest do
  use ExUnit.Case, async: true
  use RethinkDB.Connection
  import RethinkDB.Query

  alias RethinkDB.Record
  alias RethinkDB.Response

  setup_all do
    start_link()
    :ok
  end

  test "args" do
    q = [%{a: 5, b: 6}, %{a: 4, c: 7}] |> pluck(args(["a","c"]))
    %Record{data: data} = run q
    assert data == [%{"a" => 5}, %{"a" => 4, "c" => 7}]
  end

  test "binary" do
    d = << 220, 2, 3, 4, 5, 192 >>
    q = binary d
    %Record{data: data} = run q
    assert data == %RethinkDB.Pseudotypes.Binary{data: d}
    q = binary data
    %Record{data: result} = run q
    assert data == result
  end

  test "do_r" do
    q = do_r fn -> 5 end
    %Record{data: data} = run q
    assert data == 5
    q = [1,2,3] |> do_r(fn x -> x end)
    %Record{data: data} = run q
    assert data == [1,2,3]
  end

  test "branch" do
    q = branch(true, 1, 2)
<<<<<<< HEAD
    {:ok, %Record{data: data}} = run q
    assert data == 1
    q = branch(false, 1, 2)
    {:ok, %Record{data: data}} = run q
    assert data == 2
=======
    %Record{data: data} = run q
    assert data == 1 
    q = branch(false, 1, 2)
    %Record{data: data} = run q
    assert data == 2 
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
  end

  test "error" do
    q = do_r(fn -> error("hello") end)
    %Response{data: data} = run q
    assert data["r"] == ["hello"]
  end

  test "default" do
    q = 1 |> default("test")
    %Record{data: data} = run q
    assert data == 1
    q = nil |> default("test")
    %Record{data: data} = run q
    assert data == "test"
  end

  test "js" do
    q = js "[40,100,1,5,25,10].sort()"
    %Record{data: data} = run q
    assert data == [1,10,100,25,40,5] # couldn't help myself...
  end

  test "coerce_to" do
    q = "91" |> coerce_to("number")
    %Record{data: data} = run q
    assert data == 91
  end

  test "type_of" do
    q = "91" |> type_of
    %Record{data: data} = run q
    assert data == "STRING"
    q = 91 |> type_of
    %Record{data: data} = run q
    assert data == "NUMBER"
    q = [91] |> type_of
    %Record{data: data} = run q
    assert data == "ARRAY"
  end

  test "info" do
    q = [91] |> info
    %Record{data: %{"type" => type}} = run q
    assert type == "ARRAY"
  end

  test "json" do
    q = "{\"a\": 5, \"b\": 6}" |> json
    %Record{data: data} = run q
    assert data == %{"a" => 5, "b" => 6}
  end

  test "http" do
    q = "http://httpbin.org/get" |> http
    %Record{data: data} = run q
    %{"args" => %{},
      "headers" => _,
      "origin" => _, "url" => "http://httpbin.org/get"} = data
  end

  test "uuid" do
<<<<<<< HEAD
    q = uuid()
    {:ok, %Record{data: data}} = run q
=======
    q = uuid  
    %Record{data: data} = run q
>>>>>>> parent of 29e485b... Switch to :ok/:error tuple response
    assert String.length(String.replace(data, "-", ""))  == 32
  end
end
