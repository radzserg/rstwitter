defmodule RsTwitter.Credentials do
  @moduledoc """
  Keeps user authentication data for the request
  """
  @enforce_keys [:token, :token_secret]
  defstruct token: nil, token_secret: nil
end
