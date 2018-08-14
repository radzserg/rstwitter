defmodule RsTwitterTest do
  use ExUnit.Case, async: true
  doctest RsTwitter

  import Mox
  setup :verify_on_exit!

  test "request to twitter API" do
    response = %HTTPoison.Response{body: "[{\"id\": 123}]",
      headers: [{"x-rate-limit-reset", "1534246050"}],
      status_code: 200
    }
    RsTwitter.Http.ClientMock
      |> expect(:request, fn (:get, _url, _body, _headers) -> {:ok, response} end)

    credentials = %RsTwitter.Credentials{token: "token", token_secret: "secret"}
    request = %RsTwitter.Request{endpoint: "users/lookup", parameters: %{"screen_name" => "johndoe"},
      credentials: credentials}

    response = %RsTwitter.Response{
        body: [%{"id" => 123}],
        headers: [{"x-rate-limit-reset", "1534246050"}],
        status_code: 200
    }
    assert {:ok, response} == RsTwitter.request(request)
  end



end
