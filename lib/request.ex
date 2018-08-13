defmodule RsTwitter.Request do
  @moduledoc """
  Keeps request data
  """
  @enforce_keys [:endpoint]
  defstruct endpoint: nil, method: :get, parameters: %{}, credentials: nil
end