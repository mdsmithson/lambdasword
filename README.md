# LambdaSword

![image](https://github.com/user-attachments/assets/c22e37ed-efc6-46f2-afd3-b780dc2f042c)

Lambda Calculus inspired KJV Bible querying and graphing framework

## Installation

Install Elixir.
Download files and run iex -S mix in the command prompt of the directory.

Lambdasword.word("good")

iex(4)> Lambdasword.word("breadth",:chron) |> Enum.take(1)
[
  {1,
   [
     {{18, 1}, "Job 37:10",
      "By the breath of God frost is given: and the breadth of the waters is straitened."},
     {{18, 1}, "Job 38:18",
      "Hast thou perceived the breadth of the earth? declare if thou knowest it all."}
   ]}
]
