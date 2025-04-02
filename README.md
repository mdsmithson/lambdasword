# LambdaSword

![image](https://github.com/user-attachments/assets/c22e37ed-efc6-46f2-afd3-b780dc2f042c)

Lambda Calculus inspired KJV Bible querying and graphing framework

## Installation

Install Elixir.
Download files and run iex -S mix in the command prompt of the directory.

Find all verses that have the word "good" and order the chapters chronologically, taking the first book.

Lambdasword.word("good")

```elixir
iex(34)> Lambdasword.word("breadth",:chron) |> Enum.take(2)
[
  {"Job",
   [
     {{18, 1}, "Job 37:10",
      "By the breath of God frost is given: and the breadth of the waters is straitened."},
     {{18, 1}, "Job 38:18",
      "Hast thou perceived the breadth of the earth? declare if thou knowest it all."}
   ]},
  {"Genesis",
   [
     {{1, 2}, "Genesis 13:17",
      "Arise, walk through the land in the length of it and in the breadth of it; for I will give it unto thee."},
     {{1, 2}, "Genesis 6:15",
      "And this [is the fashion] which thou shalt make it [of]: The length of the ark [shall be] three hundred cubits, the breadth of it fifty cubits, and the height of it thirty cubits."}
   ]}
]
```
