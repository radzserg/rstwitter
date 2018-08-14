defmodule RsTwitterTest.Response do
  use ExUnit.Case, async: true
  doctest RsTwitter.Response

  test "fetch rate_limit_remaining" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: headers()}
    assert 897 == RsTwitter.Response.rate_limit_remaining(response)
  end

  test "fetch rate_limit_remaining returns nil" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: []}
    refute RsTwitter.Response.rate_limit_remaining(response)
  end

  test "fetch rate_limit_reset" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: headers()}
    assert 1_534_246_050 == DateTime.to_unix(RsTwitter.Response.rate_limit_reset(response))
  end

  test "fetch rate_limit_reset returns nil" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: []}
    refute RsTwitter.Response.rate_limit_reset(response)
  end

  defp headers() do
    [
      {"x-frame-options", "SAMEORIGIN"},
      {"x-rate-limit-limit", "900"},
      {"x-rate-limit-remaining", "897"},
      {"x-rate-limit-reset", "1534246050"}
    ]
  end
end
