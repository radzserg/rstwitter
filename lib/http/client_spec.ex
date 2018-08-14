defmodule RsTwitter.Http.ClientSpec do
  @callback request(atom(), String.t(), map(), list()) :: {:ok, %HTTPoison.Response{}}
end
