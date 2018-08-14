defmodule RsTwitter.Http.ClientSpec do

  @callback request(atom(), string(), map(), list()) :: {:ok, %HTTPoison.Response{}}
end