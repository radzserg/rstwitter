defmodule RsTwitter.Response do
  @moduledoc """
  Keeps authentication data for the request
  """
  @enforce_keys [:status_code, :body, :headers]
  defstruct status_code: nil, body: nil, headers: []

  import RsTwitter.Http.Headers, only: [fetch_header: 2]

  def rate_limit_remaining(response = %RsTwitter.Response{}) do
    remainging = fetch_header(response.headers, "x-rate-limit-remaining")
    if remainging, do: String.to_integer(remainging), else: nil
  end

  def rate_limit_reset(response = %RsTwitter.Response{}) do
    remainging = fetch_header(response.headers, "x-rate-limit-reset")
    if remainging, do: DateTime.from_unix!(String.to_integer(remainging)), else: nil
  end
end
