defmodule RsTwitterTest.Auth do
  use ExUnit.Case, async: true
  doctest RsTwitter.Auth

  import RsTwitter.Http.Headers, only: [fetch_header: 2]

  test "it append Authorization header" do
    user_credentials = %RsTwitter.Credentials{token: "some-token", token_secret: "secret"}
    url = "http://example.com"
    params = %{"screen_name" => "johndoe"} |> Map.to_list()

    headers =
      [{"X-Header", "some value"}]
      |> RsTwitter.Auth.append_authorization_header(:get, url, params, user_credentials)

    assert fetch_header(headers, "Authorization")
  end
end
