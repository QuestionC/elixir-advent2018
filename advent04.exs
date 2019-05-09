defmodule Advent04 do
    # Parse a string of the form 
    # [1518-11-01 00:00] Guard #10 begins shift
    # [1518-11-01 00:05] falls asleep
    # [1518-11-01 00:25] wakes up
    def string_to_data(parse_me) do
        split = Regex.run(~r/\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] (.*)/, parse_me)
        [year, month, day, hour, minute] = Enum.slice(split, 1, 5) |> Enum.map(&String.to_integer/1)
        action_str = List.last(split)
        
        time = %NaiveDateTime{year: year, month: month, day: day, hour: hour, minute: minute, second: 0}
        action = cond do
            action_str == "falls asleep" -> :asleep
            action_str == "wakes up" -> :wake
            true -> 
                guard_id = Regex.run(~r/Guard #(\d+) begins shift/, action_str, capture: :all_but_first)
                if guard_id == nil do
                    raise "Can't parse #{parse_me}"
                else
                    String.to_integer(List.first(guard_id))
                end
        end
        {time, action}
    end
    def chunk_before(enum, test) do
        Enum.chunk_while(enum, [], 
            fn 
                elem, [] -> {:cont, [elem]}
                elem, acc ->
                    if test.(elem) do
                        {:cont, Enum.reverse(acc), [elem]}
                    else
                        {:cont, [elem | acc]}

                    end
            end,
            fn acc -> {:cont, Enum.reverse(acc), []} end
        )
    end
    def sort_by_time(enum) do
        Enum.sort(enum, fn {timeA,_},{timeB,_} -> NaiveDateTime.compare(timeA, timeB) == :lt end)
    end
    def chunk_by_guard(enum) do
        Advent04.chunk_before(enum, fn{_time, type} -> is_integer(type) end)
    end
    def file_to_lines(filename) do
        File.read!(filename) |>
        String.trim |>
        String.split("\n")
    end
    def guardchunk_to_minutes (guardchunk) do
        [{_,guard_id} | tail] = guardchunk
        { guard_id, 
            tail |> 
            Enum.chunk_every(2) |>
            Enum.reduce([], fn([{t1,:asleep},{t2,:wake}],acc) ->
                [t1.minute..t2.minute-1 | acc]
            end
            )
        }
    end
    def enum_to_map(enum) do
        Enum.reduce(enum, %{}, fn({key, value}, acc) ->
            # Map.put(acc, key, Enum.concat(acc[key]||[],value)
            
            )
        end
        )
    end
    def ranges_to_countmap(enum) do
        Enum.concat(enum) |>
        Enum.reduce(%{}, fn n,acc -> update_in(acc[n], &((&1||0) +1)) end)
    end
end

# Star 1: Find the guard that has the most minutes asleep.
# What minute does that guard sleep the most?
Advent04.file_to_lines("input4.txt") |>
Enum.map(&Advent04.string_to_data/1) |>
Advent04.sort_by_time |>
Advent04.chunk_by_guard |>
Enum.map(&Advent04.guardchunk_to_minutes/1) |>
Advent04.enum_to_map |>
IO.inspect
