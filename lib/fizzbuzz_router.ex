defmodule Fizzbuzz.Router do
  use Plug.Router
  import ElixirFizzbuzz

  plug :match
  plug :dispatch

  get("/") do
    conn |> redirect_to("/fizzbuzz") |> send_resp()
  end

  get("/fizzbuzz") do
    input = fetch_query_params(conn).params["input"]
    conn |> validate_fizzbuzz(input) |> send_resp()
  end

  get("/fizzbuzz/bad_input") do
    conn |> send_resp(200, "bad input")
  end

  match _ do
    conn |> send_resp(404, "oops, something went wrong")
  end


  defp redirect_to(conn, to, message \\ "you are being redirected") do
    conn |> put_resp_header("location", to) |> resp(303, message)
  end

  defp validate_fizzbuzz(conn, input) do
    
    cond do
      not is_bitstring(input) ->
        response = EEx.eval_file("views/index.eex", [result: nil])
        conn |> put_resp_content_type("html") |> resp(200, response)
      Regex.match?(~r{\A\d+\Z}, input) ->
        result = input |> String.to_integer |> fizzbuzz
        response = EEx.eval_file("views/index.eex", [result: result])
        conn |> put_resp_content_type("html") |> resp(200, response)
      true ->
        conn 
          |> put_resp_content_type("text/plain") 
          |> redirect_to("/fizzbuzz/bad_input")
    end
  end

end
