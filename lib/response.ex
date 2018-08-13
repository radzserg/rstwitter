defmodule RsTwitter.Response do
  @moduledoc """
  Keeps authentication data for the request
  """
  @enforce_keys [:status_code, :body, :headers]
  defstruct status_code: nil, body: nil, headers: []
end