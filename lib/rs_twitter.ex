defmodule RsTwitter do
  @http_client Application.get_env(:rs_twitter, :http_client, RsTwitter.Http.Client)

  @moduledoc """
  Twitter API SDK

  This is low level twitter client. The idea behind this package is not to define special functions for each endpoint,
  but use generic request structure that will allow to make requests to any of twitter API endpoints.

  ## Setup
  ```
    # Add your twitter app credentials to your app config
    config :rs_twitter,
      consumer_key: "your_app_consumer_key",
      consumer_secret: "your_app_consumer_secret"
  ```

  ## How to use
  ```
    iex(1)> %RsTwitter.Request{endpoint: "followers/ids", parameters: %{"screen_name" => "radzserg"}}
      |> RsTwitter.request()

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
  ```


  ## Handle response/errors

  ```
    %RsTwitter.Request{method: :post, endpoint: "followers/ids", parameters: %{"screen_name" => "radzserg"}}
      |> RsTwitter.request()
      |> proceed_response()

    defp proceed_response({:ok, response = %RsTwitter.Response{status_code: 200,
      %{body: %{"ids" => ids, "next_cursor" => next_cursor}}}}) do
      # everything is ok do what you need with IDs
    end

    defp proceed_response({:error, response = %RsTwitter.Response{body: %{"errors" => errors}}}) do
      # successfull request but some twitter error happened,
      # decide what to do with the error
      # https://developer.twitter.com/en/docs/basics/response-codes.html
      # For example:
      if RsTwitter.Response.has_error_code?(response, 88) do
        # rate limit reached
      end
    end
    defp proceed_response({:error, error}) when is_atom(error) do
      # network error happened during request to twitter
    end
  ```

  ## User Authentication

  We worked with application authentication. i.e. we send only application `consumer_key` and `consumer_secret`.
  In order to use user authentication we need to add `%RsTwitter.Credentials` to `RsTwitter.Request`.

  *RsTwitter* do not obtain user token/secret. Please use specific packages like
  [Überauth Twitter](https://github.com/ueberauth/ueberauth_twitter) to obtain user credentials.

  As soon as you have user token and secret just add them to request.

  ```
    iex(1)> credentials = %RsTwitter.Credentials{token: "your_user_token",
      token_secret: "your_user_secret"}

    iex(2)> request = %RsTwitter.Request{endpoint: "followers/ids",
      parameters: %{"user_id" => 123}, credentials: credentials}
  ```

  """

  @twitter_url "https://api.twitter.com/1.1/"

  @doc """
  Makes request to twitter API

  Provide valid %RsTwitter.Request{} to make request

  ###  Common usage

  ```
  %RsTwitter.Request{method: :post, endpoint: "friendships/create",
    parameters: %{"screen_name" => "radzserg"}, credentials: credentials}
    |> RsTwitter.request()
  ```

  ### Examples

  ```
  %RsTwitter.Request{endpoint: "followers/ids", parameters: %{"user_id" => 123},
    credentials: credentials}
  %RsTwitter.Request{endpoint: "users/lookup", parameters: %{"screen_name" => "johndoe"},
    credentials: credentials}
  %RsTwitter.Request{method: :post, endpoint: "friendships/create",
    parameters: %{"screen_name" => "radzserg"}, credentials: credentials}
  ```
  Build request using
  [Twitter Docs](https://developer.twitter.com/en/docs/accounts-and-users/follow-search-get-users/api-reference)
  """
  @spec request(RsTwitter.Request.t()) :: {:ok, RsTwitter.Response.t()} | {:error, atom()}
  def request(request = %RsTwitter.Request{}) do
    url = build_url(request)

    headers =
      [{"Content-Type", "application/json"}]
      |> RsTwitter.Auth.append_authorization_header(
        request.method,
        url,
        [],
        request.credentials
      )

    @http_client.request(request.method, url, [], headers)
    |> handle_response
  end

  defp handle_response({:ok, response = %HTTPoison.Response{}}) do
    %{status_code: status_code, body: body, headers: headers} = response
    body = Poison.decode!(body)
    if status_code == 200 do
      {:ok, %RsTwitter.Response{status_code: status_code, body: body, headers: headers}}
    else
      {:error, %RsTwitter.Response{status_code: status_code, body: body, headers: headers}}
    end
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  defp build_url(request = %RsTwitter.Request{}) do
    url = @twitter_url <> request.endpoint <> ".json"

    query_string = URI.encode_query(request.parameters)
    if query_string == "", do: url, else: url <> "?#{query_string}"
  end
end
