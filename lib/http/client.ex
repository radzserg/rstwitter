defmodule RsTwitter.Http.Client do
  @behaviour RsTwitter.Http.ClientSpec

  def request(method, url, body, headers) do
    HTTPoison.start()
    HTTPoison.request(method, url, body, headers)
  end
end
