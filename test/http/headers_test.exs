defmodule RsTwitterTest.Http.Headers do
  use ExUnit.Case, async: true
  doctest RsTwitter.Http.Headers

  test "fetch correct header value" do
    assert "897" == RsTwitter.Http.Headers.fetch_header(headers(), "x-rate-limit-remaining")
    assert "897" == RsTwitter.Http.Headers.fetch_header(headers(), "X-Rate-Limit-remaining")
    refute RsTwitter.Http.Headers.fetch_header(headers(), "undefined")
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
