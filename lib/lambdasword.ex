defmodule Lambdasword do
  @moduledoc """
  Documentation for `Lambdasword`.
  """

  @doc """
  Hello Bible.

  ## Examples

      iex> Lambdasword.hello()
      :world

  """

  def kjv do
    Jason.decode!(File.read!("lib/kjv.json"))
  end

  def order do
    # Name, Canonical, Chronological
    %{
    "Genesis" => {1, 2},
    "Exodus" => {2, 3},
    "Leviticus" => {3, 4},
    "Numbers" => {4, 5},
    "Deuteronomy" => {5, 6},
    "Joshua" => {6, 8},
    "Judges" => {7, 9},
    "Ruth" => {8, 10},
    "1 Samuel" => {9, 14},
    "2 Samuel" => {10, 15},
    "1 Kings" => {11, 29},
    "2 Kings" => {12, 30},
    "1 Chronicles" => {13, 35},
    "2 Chronicles" => {14, 36},
    "Ezra" => {15, 34},
    "Nehemiah" => {16, 39},
    "Esther" => {17, 37},
    "Job" => {18, 1},
    "Psalms" => {19, 7},
    "Proverbs" => {20, 12},
    "Ecclesiastes" => {21, 13},
    "Solomons Song" => {22, 11},
    "Isaiah" => {23, 22},
    "Jeremiah" => {24, 28},
    "Lamentations" => {25, 27},
    "Ezekiel" => {26, 26},
    "Daniel" => {27, 31},
    "Hosea" => {28, 20},
    "Joel" => {29, 17},
    "Amos" => {30, 19},
    "Obadiah" => {31, 16},
    "Jonah" => {32, 18},
    "Micah" => {33, 21},
    "Nahum" => {34, 23},
    "Habakkuk" => {35, 25},
    "Zephaniah" => {36, 24},
    "Haggai" => {37, 32},
    "Zechariah" => {38, 33},
    "Malachi" => {39, 38},
    "Matthew" => {40, 42},
    "Mark" => {41, 43},
    "Luke" => {42, 49},
    "John" => {43, 62},
    "Acts" => {44, 54},
    "Romans" => {45, 48},
    "1 Corinthians" => {46, 46},
    "2 Corinthians" => {47, 47},
    "Galatians" => {48, 41},
    "Ephesians" => {49, 50},
    "Philippians" => {50, 51},
    "Colossians" => {51, 53},
    "1 Thessalonians" => {52, 44},
    "2 Thessalonians" => {53, 45},
    "1 Timothy" => {54, 55},
    "2 Timothy" => {55, 58},
    "Titus" => {56, 56},
    "Philemon" => {57, 52},
    "Hebrews" => {58, 60},
    "James" => {59, 40},
    "1 Peter" => {60, 57},
    "2 Peter" => {61, 59},
    "1 John" => {62, 63},
    "2 John" => {63, 64},
    "3 John" => {64, 65},
    "Jude" => {65, 61},
    "Revelation" => {66, 66}
  }
  end

  def book_by_order(o,i), do: order() |> Enum.map(fn {x,o_} -> {x,o_ |> elem(case o do :chron -> 1; :canon -> 0 end)} end ) |> Enum.filter(fn {x,y} -> y == i end) |> List.first |> elem(0)

  def order(results,order), do: results |> Enum.sort_by(fn {x,y,z} -> x |> elem(case order do :chron -> 1; :canon -> 0 end) end)

  def order(chapter), do: Map.get(order(),chapter)  

  def kjv({:chapter, chapter}), do: kjv() |> Enum.filter(fn {x,y} -> String.match?(x,~r/#{chapter}/) end)

  def kjv({:word, word}), do: kjv() |> Enum.filter(fn {x,y} -> String.match?(y,~r/#{word}/) end)

  def kjv_with_order({:word,word}), do: kjv({:word,word}) |> Enum.map(fn {c,v} -> {order(c|>String.split(" ")|>List.pop_at(-1)|>elem(1)|>Enum.join(" ")),c,v} end)  

  # Lambdasword.kjv_with_order({:word,"good"}) |> Lambdasword.order(:chron) |> Enum.group_by(fn {o,c,v} -> o |> elem(0) end)
  def word(w,o \\ :canon), do: kjv_with_order({:word,w}) |> order(o) |> Enum.group_by(fn {o_,c,v} -> o_ |> elem(case o do :chron -> 1; :canon -> 0 end) end) |> Enum.map(fn {x,y} -> {book_by_order(o,x),y} end)

end
