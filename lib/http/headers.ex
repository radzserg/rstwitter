defmodule RsTwitter.Http.Headers do
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
