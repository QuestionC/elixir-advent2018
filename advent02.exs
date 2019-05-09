require Itertools

defmodule Advent02 do
    def count_elements(enum) do
        enum |>
        Enum.reduce(%{}, fn(add_me, acc) ->
            Map.put(acc, add_me, (acc[add_me] || 0) + 1) end
        )
    end
    def add_maps(m1, m2) do
        Map.merge(m1, m2, fn _, v1, v2 -> v1 + v2 end)
    end
    def string_similarity(s1, s2) do
        Enum.zip(String.graphemes(s1), String.graphemes(s2)) |>
        Enum.reject(fn {a, b} -> a != b end) |> 
        Enum.map(fn {a, _} -> a end) |>
        Enum.join
    end
    def foo([head | tail]) do
        for elem <- tail do
            string_similarity(head, elem) 
        end ++ foo(tail)
    end
end

# Part 1, Find the number of strings with 2 identical characters
# And the number of strings with 3 identical characters
x = File.read!("input2.txt") |>
String.split |>
Enum.reduce(%{}, 
    fn (string, acc) ->
        string |>
        String.graphemes |>
        Advent02.count_elements |>
        Map.values |>
        Map.new(fn(x) -> {x, 1} end) |>
        Advent02.add_maps(acc)
    end
) |>
IO.inspect

IO.puts x[2] * x[3]

# Part 2, find the common characters between the two most similar strings
File.read!("input2.txt") |>
String.split |>
Itertools.combinations(2) |>
Enum.map(fn [x, y] -> Advent02.string_similarity(x, y) end ) |>
Enum.max_by(&String.length/1) |>
IO.puts


