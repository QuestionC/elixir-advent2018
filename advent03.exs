defmodule Advent03 do

    # Parse a string of the form "#1 @ 123,456 22x33"
    def string_to_data(parse_me) do
        split = Regex.run(~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/, parse_me)
        if split == nil do
            IO.puts("Can't parse #{parse_me}")
            nil
        else 
            [id, x, y, w, h] = Enum.slice(split, 1..-1) |> Enum.map(&String.to_integer/1)
            %{id: id, x: x, y: y, w: w, h: h}
        end
    end
    def plot_area(plot_me) do
        for x <- plot_me.x .. plot_me.x + plot_me.w - 1, 
            y <- plot_me.y .. plot_me.y + plot_me.h - 1 do
                {{x, y}, plot_me.id}
            end
            |> 
        Map.new
    end
    def plot_area2(plot_me) do
        area = for x <- plot_me.x .. plot_me.x + plot_me.w - 1, 
            y <- plot_me.y .. plot_me.y + plot_me.h - 1 do
                {x, y}
            end |>
        MapSet.new()
        {plot_me.id, area}
    end
end

# Star 1
flat_map = File.read!("input3.txt") |>
String.trim |> 
String.split("\n") |> 
Enum.map(&Advent03.string_to_data/1) |> 
Enum.flat_map(&Advent03.plot_area/1)

{full_map, collisions} = flat_map |>
Enum.reduce({%{}, MapSet.new}, 
    fn({pos, id}, {acc_map, acc_set}) -> 
        if Map.has_key?(acc_map, pos) do 
            { Map.put(acc_map, pos, 'X'), MapSet.put(acc_set, acc_map[pos]) |> MapSet.put(id)} 
        else { Map.put(acc_map, pos, id), acc_set} 
        end 
    end )

Enum.count(full_map, fn {_k, v} -> v == 'X' end) |>
IO.puts

# Star 2
seen_ids = MapSet.new(for {_k,v} <- flat_map do v end)
MapSet.difference(MapSet.new(seen_ids), collisions) |>
IO.inspect
