defmodule RsTwitterTest.Auth do
  use ExUnit.Case, async: true
  doctest RsTwitter.Auth

  test "it append Authorization header" do
    user_credentials = %RsTwitter.Credentials{token: "some-token", token_secret: "secret"}
    url = "http://example.com"
    params = %{"screen_name" => "johndoe"} |> Map.to_list
    headers = [{"X-Header", "some value"}]
     |> RsTwitter.Auth.append_authorization_header(:get, url, params, user_credentials)

    assert fetch_header(headers, "Authorization")
  end

  defp fetch_header(headers, name) do
    name = String.downcase(name)
    header = Enum.find(headers, fn({header_name, _value}) ->
      String.downcase(header_name) == name
    end)
    case header do
      {_name, value} -> value
      _ -> nil
    end
  end
end
