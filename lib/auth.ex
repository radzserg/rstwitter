defmodule RsTwitter.Auth do
  alias RsTwitter.Credentials

  def append_authorization_header(headers, method, url, body, user_credentials = %Credentials{}) do
    {consumer_key, consumer_secret} = fetch_consumer_credentials()

    creds =
      OAuther.credentials(
        consumer_key: consumer_key,
        consumer_secret: consumer_secret,
        token: user_credentials.token,
        token_secret: user_credentials.token_secret
      )

    method = Atom.to_string(method)
    params = OAuther.sign(method, url, body, creds)

    {header, _req_params} = OAuther.header(params)
    headers ++ [header]
  end

  defp fetch_consumer_credentials() do
    consumer_key = Application.get_env(:rs_twitter, :consumer_key)

    if !consumer_key do
      raise ":consumer_key and :consumer_secret must be set"
    end

    consumer_secret = Application.get_env(:rs_twitter, :consumer_secret)

    if !consumer_secret do
      raise ":consumer_secret and :consumer_secret must be set"
    end

    {consumer_key, consumer_secret}
  end
end
