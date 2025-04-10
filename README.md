# LambdaSword

![image](https://github.com/user-attachments/assets/c22e37ed-efc6-46f2-afd3-b780dc2f042c)

Lambda Calculus inspired KJV Bible querying and graphing framework

## Installation

Install Elixir.
Download files and run iex -S mix in the command prompt of the directory.
Install Docker and Ollama (Example is configured to use 3 seperate instances of ollama with 3 gpus)
```cmd
docker run -d --gpus "device=0" -v ollama1:/root/.ollama -p 11434:11434 -e CUDA_VISIBLE_DEVICES=0 --name ollama1 ollama/ollama
docker run -d --gpus "device=1" -v ollama2:/root/.ollama -p 11435:11434 -e CUDA_VISIBLE_DEVICES=1 --name ollama2 ollama/ollama
```

```cmd
git clone http://github.com/mdsmithson/lambdasword
cd lambdasword
mix deps.get
iex -S mix
```

Find all verses that have the word "breadth" and order the chapters chronologically, taking the first book.

Lambdasword.word("breadth")

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



```elixir
iex(14)> Lambdasword.references("Rom11:25",:accordingto)
[
  ["Isaiah 29:10", ["Prophetic"]],
  ["Romans 9:13", ["Prophetic"]],
  ["Hosea 1:10", ["Prophetic"]],
  ["Romans 9:25", ["Prophetic", "Mystery"]],
  ["Isaiah 29:22-23", ["Prophetic", "Mystery"]],
  ["Isaiah53:1", ["Prophetic"]],
  ["Ephesians 2:12", ["Mystery"]],
  ["Isaiah 29:22-24", ["Prophetic", "Mystery"]],
  ["Romans 9:27", ["Prophetic", "Mystery"]],
  ["Romans 9:6", ["Mystery", "Prophetic"]],
  ["Romans 9:26", ["Prophetic", "Mystery"]],
  ["Isaiah 29:22", ["Prophetic", "Mystery"]],
  ["Romans 9:22", ["Prophetic", "Mystery"]],
  ["Ezekiel 37:19", ["Prophetic"]],
  ["Romans 9:32", ["Prophetic", "Mystery"]],
  ["Romans 9:30", ["Mystery", "Prophetic"]]
]
```

Dispensational research analysis

```elixir
iex(10)> Lambdasword.references("Eph3:9",:audience)
[
  ["Colossians 1:27", ["Both", "Gentiles"]],
  ["Romans 11:25", ["Gentiles", "Both"]],
  ["Ephesians 2:7", ["Gentiles", "Both"]],
  ["Romans 16:25", ["Gentiles", "Both"]],
  ["2Cor12:4", ["Both", "Gentiles"]],
  ["Eph2:7", ["Both", "Gentiles"]],
  ["Galatians 1:11", ["Both", "Gentiles"]],
  ["2 Corinthians 4:6", ["Both", "Gentiles"]],
  ["Acts 26:22", ["Both", "Gentiles"]],
  ["1Cor2:7", ["Gentiles", "Both"]],
  ["2 Corinthians 12:6", ["Gentiles", "Both"]],
  ["Galatians 1:16", ["Both", "Gentiles"]],
  ["2Cor12:6", ["Gentiles", "Both"]],
  ["1 Corinthians 2:7", ["Both", "Gentiles"]]
]
iex(11)> Lambdasword.references("1Tim1:16",:audience)
[
  ["Romans 3:25", ["Both", "Gentiles"]],
  ["2 Timothy 4:11", ["Both", "Gentiles"]],
  ["Titus 3:4", ["Gentiles", "Both"]],
  ["Romans 3:4", ["Gentiles", "Both"]],
  ["2Thessalonians 2:10", ["Gentiles", "Both"]],
  ["Hebrews 7:3", ["Both", "Gentiles"]],
  ["Romans 3:20", ["Gentiles", "Both"]],
  ["Ephesians 3:8", ["Both", "Gentiles"]],
  ["Galatians 2:20", ["Both"]],
  ["Ephesians 2:8", ["Both", "Gentiles"]],
  ["Matthew 20:28", ["Both"]],
  ["2Cor11:23", ["Both", "Gentiles"]],
  ["Titus 3:9", ["Gentiles", "Both"]],
  ["1 Timothy 1:15", ["Both", "Gentiles"]],
  ["1 Corinthians 15:9", ["Gentiles", "Both"]],
  ["3John 9", ["Gentiles", "Both"]],
  ["2 Timothy 3:16", ["Both"]],
  ["2Cor12:11", ["Both", "Gentiles"]],
  ["2Tim 3:15", ["Both"]],
  ["Ephesians 2:4", ["Both", "Gentiles"]],
  ["Hebrews 2:14", ["Both", "Gentiles"]],
  ["Acts 26:14", ["Gentiles", "Both"]],
  ["Titus 3:5", ["Both", "Gentiles"]],
  ["2 Corinthians 12:10", ["Both", "Gentiles"]],
  ["2Tim 1:13", ["Gentiles", "Both"]]
]
iex(12)> Lambdasword.references("Acts2:38",:audience)
[
  ["Joel 2:32", ["Both"]],
  ["Matthew 3:15", ["Both", "Israel", "Both (Israel/Gentiles)"]],
  ["Ezekiel 36:26", ["Both", "Israel"]],
  ["Acts 22:16", ["Both"]],
  ["Ezekiel 36:25-27", ["Both", "Israel"]],
  ["Ezekiel 36:25", ["Both", "Israel"]],
  ["Hebrews 10:26", ["Both", "Gentiles"]],
  ["Mark 16:16", ["Both"]],
  ["Ezekiel 36:25-26", ["Both", "Israel"]],
  ["Hebrews10:26-27", ["Both", "Gentiles"]],
  ["Mark16:16", ["Both"]],
  ["Hebrews10:16", ["Gentiles", "Both"]],
  ["Hebrews6:1", ["Both", "Gentiles"]],
  ["Hebrews 13:8", ["Both"]],
  ["Luke 24:47", ["Both"]],
  ["Joel 2:28", ["Both"]],
  ["Hebrews 6:1-2", ["Both", "Gentiles"]],
  ["Hebrews10:26", ["Both", "Gentiles"]],
  ["Matthew 3:11", ["Both"]],
  ["Hebrews6:2", ["Both", "Gentiles"]],
  ["Mark 1:4", ["Both", "Gentiles"]]
]
```


Ranking References by given verse
```elixir
iex(153)> a = Lambdasword.references_by_weight("Isa11")                                                                                                                                                                                                                                                                                                                                                                                                                                      
[
  "Isa11",
  [
    [
      [
        {"Zechariah 12:3",
         "# And in that day will I make Jerusalem a burdensome stone for all people: all that burden themselves with it shall be cut in pieces, though all the people of the earth be gathered together against it."}
      ],
      "2"
    ],
    [
      [
        {"Jeremiah 23:5",
         "# Behold, the days come, saith the LORD, that I will raise unto David a righteous Branch, and a King shall reign and prosper, and shall execute judgment and justice in the earth."}
      ],
      87
    ],
    [
      [
        {"Genesis 3:15",
         "And I will put enmity between thee and the woman, and between thy seed and her seed; it shall bruise thy head, and thou shalt bruise his heel."}
      ],
      72
    ],
    [
      [
        {"Romans 11:26",
         "And so all Israel shall be saved: as it is written, There shall come out of Sion the Deliverer, and shall turn away ungodliness from Jacob:"}
      ],
      67
    ],
```