defmodule RsTwitter.Http.Headers do

  @doc """
  Find header value for provider header name
  """
  @spec fetch_header(list(), String.t()) :: String.t() | nil
  def fetch_header(headers, name) do
    name = String.downcase(name)

    header =
      Enum.find(headers, fn {header_name, _value} ->
        String.downcase(header_name) == name
      end)

    case header do
      {_name, value} -> value
      _ -> nil
    end
  end
end
