defmodule RsTwitter.Response do
  @moduledoc """
  Keeps authentication data for the request
  """
  @enforce_keys [:status_code, :body, :headers]
  defstruct status_code: nil, body: nil, headers: []

  import RsTwitter.Http.Headers, only: [fetch_header: 2]

  @doc """
  Check if response is successfull
  """
  def success?(response = %RsTwitter.Response{}) do
    response.status_code == 200
  end

  @doc """
  Defines the number of requests left for the 15 minute window
  """
  def rate_limit_remaining(response = %RsTwitter.Response{}) do
    remainging = fetch_header(response.headers, "x-rate-limit-remaining")
    if remainging, do: String.to_integer(remainging), else: nil
  end

  @doc """
  Defines the remaining window before the rate limit resets, in UTC epoch seconds
  """
  def rate_limit_reset(response = %RsTwitter.Response{}) do
    remainging = fetch_header(response.headers, "x-rate-limit-reset")
    if remainging, do: DateTime.from_unix!(String.to_integer(remainging)), else: nil
  end
end
