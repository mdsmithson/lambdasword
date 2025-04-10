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

  def kjv, do: Jason.decode!(File.read!("lib/kjv.json"))
  def kjv({:verse,v}), do: kjv() |> Enum.filter(fn {i,s} -> i == v end)

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

  # def related(x) do
  #   client = Ollama.init("http://localhost:11435/api/")
  #   IO.puts Ollama.completion(client, [  model: "mistral",  prompt: x]) |> elem(1) |> Map.get("response")
  # end

  @moduledoc """
  An external set of functions to interact with Ollama local servers for Bible verse reference lookups.
  """
  defmodule Parallel do
    def fmap(list, func) when is_list(list) and is_function(func) do
      list
      |> Enum.map(fn item ->
        Task.async(fn -> func.(item) end)
      end)
      |> Enum.map(&Task.await(&1, 300_000))  # 5 minutes timeout (300,000 ms)
    end

    def fmap([], _func), do: []
  end
  
  @server_map %{
    "1" => "http://192.168.7.145:11434",
    "2" => "http://192.168.7.145:11435",
    "3" => "http://192.168.7.144:11434"
  }

  @doc """
  Gets the server URL based on the server choice.
  Returns {:ok, url} or {:error, message}.
  """
  def get_server_url(server_choice) do
    case Map.get(@server_map, server_choice) do
      nil ->
        available = Map.keys(@server_map) |> Enum.join(", ")
        {:error, "Invalid server choice '#{server_choice}'. Available options are: #{available}"}
      url ->
        {:ok, url}
    end
  end

  @doc """
  Prepares the payload for the Ollama API request.
  """
  def prepare_payload(verse_reference,question) do
    %{
      model: "llama3.1:8b",
      messages: [
        %{
          role: "system",
          content: prompt(question)
        },
        %{role: "user", content: verse_reference}
      ],
      format: "json",
      stream: false
    }
  end

  def prompt(k) do
  case k do
    :ref -> """
          You are a LLM AI Natural Language Assistant. Take the given Bible verse reference (e.g., '1Cor15:3')
          and provide a single related verse reference from the King James Version (KJV) that is
          contextually connected in dispensational context and meaning. Return only the verse reference (e.g., 'Romans 5:8'),
          not the full text, in JSON format as an object with a 'answer' field.
          """
    :audience -> 
          """
          You are a LLM AI Natural Language Assistant. Take the given Bible verse from the (KJV) (e.g., 1Cor15:3) 
          and determine the intended audience—Israel, Gentiles, or Both. Return only the audience in JSON format as 
          an object with an 'answer' field.
          """
    :dispensation ->
          """
          You are a LLM AI Natural Language Assistant. Take the given Bible verse from the (KJV) (e.g., 1Cor15:3) 
          and determine the dispensational context with regard to its gospel; return back with gospel of the kingdom, 
          gospel of God, gospel of grace, everlasting gospel or gospel general. Return only the response 
          in JSON format as an object with an 'answer' field.
          """
    :accordingto ->
          """
          You are a LLM AI Natural Language Assistant. Take the given Bible verse from the (KJV) (e.g., 1Cor15:3) 
          and determine the if it is Prophetic (ie Acts3:21 Isa9 Isa11) return Prophetic if according to revelation of the mystery return Mystery. 
          Return only the response in JSON format as an object with an 'answer' field.
          """      
    :towhom ->
          """
          You are Gentile living in 2025. Take the given Bible verse from the (KJV) (e.g., 1Cor15:3) 
          and determine if it is "To you" or if is "For learning" meaning not to you but for your learning (e.g., 2Tim3:16 2Tim2:15). 
          Return only the response as "To You" or "For learning" in JSON format as an object with an 'answer' field.
          """
    [:connection_weight, v] ->
              """
          You are a LLM AI Natural Language Assistant. Take the given Bible verse reference (e.g., '1Cor15:3')
          and provide a score of how related it is in total verse reference count to #{v} that is
          contextually connected in dispensational context and meaning. Return only the score as a number 0-100
          in JSON format as an object with a 'answer' field.
          """
     end
  end

  @doc """
  Sends request to the Ollama server using :httpc and returns the response.
  Returns {:ok, result} or {:error, message}.
  """
  def send_request(payload, server_url) do
    # Start inets and set up a named profile to avoid internal issues
    with {:ok, json} <- Jason.encode(payload),
         url = String.to_charlist("#{server_url}/api/chat"),
         headers = [{'Content-Type', 'application/json'}],
         request = {url, headers, 'application/json', json},
         {:ok, result} <- :httpc.request(:post, request, [{:timeout, 30_000}], [{:body_format, :binary}]) do
      case result do
        {{_version, 200, _reason}, _headers, body} ->
          Jason.decode(body)
        {{_version, status, reason}, _headers, _body} ->
          {:error, "Server returned status #{status}: #{to_string(reason)}"}
      end
    end
  end

  @doc """
  Processes the API response and extracts the related reference.
  Returns {:ok, reference} or {:error, message}.
  """
  def process_response(result) do
    with %{"message" => %{"content" => content}} <- result,
         {:ok, evaluation} <- Jason.decode(content),
         %{"answer" => reference} <- evaluation do
      {:ok, reference}
    else
      error ->
        {:error, "Error processing response: #{inspect(error)}"}
    end
  end

  @doc """
  Main function to process a verse reference and get a related reference.
  Returns {:ok, reference} or {:error, message}.
  """
  def call_llm(server_choice, verse_reference,question) do
    with {:ok, server_url} <- get_server_url(server_choice),
         payload <- prepare_payload(verse_reference,question),
         {:ok, result} <- send_request(payload, server_url),
         {:ok, reference} <- process_response(result) do
      {:ok, reference}
    else
      {:error, message} -> {:error, message}
    end
  end

  def burst(n,servers \\ 3), do: 0..n |> Enum.map(fn x -> 1..servers |> Enum.map(fn x -> x end) end) |> List.flatten

  def ask_questions(v,q,n \\ 100), do: burst(n) |> Lambdasword.Parallel.fmap(fn x -> Lambdasword.call_llm(to_string(x),v,q) end) |> Enum.uniq |> Enum.map(fn x -> x |> elem(1) end)


  def find_connecting_references(verses,q, n \\ 100) when is_list(verses) do
    verses
    |> Lambdasword.Parallel.fmap(fn verse -> ask_questions(verse,q,n) end) |> IO.inspect
    |> Enum.reduce(fn refs, acc -> Enum.filter(refs, fn x -> x in acc end) end)
  end

  def references(verse,q) do

    Lambdasword.ask_questions(verse,:ref,15) |> Lambdasword.Parallel.fmap(fn verse -> [verse,Lambdasword.ask_questions(verse,q,15)] end)

  end

  def references_by_weight(verse), do: [verse, Lambdasword.burst(10) |> Enum.zip(Lambdasword.ask_questions(verse,:ref)) |> Lambdasword.Parallel.fmap(fn {s,v} -> [v,Lambdasword.call_llm(to_string(s),verse,[:connection_weight,v])|>elem(1)]  end)|> Enum.sort_by(fn [x,y] -> y end,:desc)]


end