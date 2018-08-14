defmodule RsTwitter do
  @http_client Application.get_env(:rs_twitter, :http_client, RsTwitter.Http.Client)

  @moduledoc """
  Twitter API SDK

  Add your twitter app credentials to your app config
  config :rs_twitter,
    consumer_key: "your_app_consumer_key",
    consumer_secret: "your_app_consumer_secret"

  iex(1)> credentials = %RsTwitter.Credentials{token: "your_user_token", token_secret: "your_user_secret"}
  iex(4)> request = %RsTwitter.Request{endpoint: "followers/ids", parameters: %{"user_id" => 123}, credentials: credentials}
  iex(5)> RsTwitter.request(request)
    {:ok,
     %RsTwitter.Response{
       body: %{
         "ids" => [55555555, 55555556, ...],
         "next_cursor" => 1593278910906579502,
         "next_cursor_str" => "1593278910906579502",
         "previous_cursor" => 0,
         "previous_cursor_str" => "0"
       },
       headers: [
         ....
         {"x-rate-limit-limit", "15"},
         {"x-rate-limit-remaining", "12"},
         {"x-rate-limit-reset", "1534264549"},
         {"x-response-time", "172"},
       ],
       status_code: 200
     }}

  """

  @twitter_url "https://api.twitter.com/1.1/"

  @doc """
  Makes request to twitter API
  """
  def request(request = %RsTwitter.Request{}) do
    url = build_url(request)
    body = build_body(request)

    headers =
      []
      |> RsTwitter.Auth.append_authorization_header(
        request.method,
        url,
        body,
        request.credentials
      )

    @http_client.request(request.method, url, body, headers)
    |> handle_response
  end

  defp handle_response({:ok, response = %HTTPoison.Response{}}) do
    %{status_code: status_code, body: body, headers: headers} = response
    body = Poison.decode!(body)
    {:ok, %RsTwitter.Response{status_code: status_code, body: body, headers: headers}}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  defp build_body(request = %RsTwitter.Request{}) do
    if request.method == :get do
      []
    else
      Map.to_list(request.parameters)
    end
  end

  defp build_url(request = %RsTwitter.Request{}) do
    url = @twitter_url <> request.endpoint <> ".json"

    if request.method == :get do
      query_string = URI.encode_query(request.parameters)
      if query_string == "", do: url, else: url <> "?#{query_string}"
    else
      url
    end
  end
end
