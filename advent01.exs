defmodule Advent01 do
    def add_to_set(add_me, {set, total}) do
        new_value = add_me + total
        if MapSet.member?(set, new_value) do
            {:halt, new_value}
        else
            {:cont, { MapSet.put(set, new_value), new_value } }
        end
    end
end

File.read!("input1.txt") |>
String.strip |>
String.split |>
Enum.map(&String.to_integer/1) |>
Stream.cycle |>
Enum.reduce_while({ MapSet.new(), 0}, &Advent01.add_to_set/2) |>
IO.puts
