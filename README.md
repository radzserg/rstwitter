# RsTwitter

**Twitter Client for Elixir**

This is low level twitter client. The idea behind this package is not to define special functions for each endpoint, 
but use generic request structure

`%RsTwitter.Request{endpoint: "followers/ids", parameters: %{"user_id" => 123}, credentials: credentials}`


Such request structure can do API request to any twitter API endpoint. 
Just browse [API Docs](https://developer.twitter.com/en/docs/accounts-and-users/follow-search-get-users/api-reference)
and create appropriate `%RsTwitter.Request{}`
 
```elixir
%RsTwitter.Request{endpoint: "followers/ids", parameters: %{"user_id" => 123}, credentials: credentials}
%RsTwitter.Request{endpoint: "users/lookup", parameters: %{"screen_name" => "radzserg"}, credentials: credentials}
%RsTwitter.Request{method: :post, endpoint: "friendships/create", parameters: %{"screen_name" => "radzserg"}, credentials: credentials}
# discover docs to build your request
``` 
 
You will get raw response object and it's your responsibility how to use it.

```elixir

{:ok,
 %RsTwitter.Response{
   body: %{
     "ids" => [1029248792367964162, 991927650775117824, 918173404812972032,
      435437746, ...],
     "next_cursor" => 1593371931590276485,
     "next_cursor_str" => "1593371931590276485",
     "previous_cursor" => 0,
     "previous_cursor_str" => "0"
   },
   headers: [
     {"x-rate-limit-limit", "15"},
     ... 
   ],
   status_code: 200
 }}


``` 
 
 
## Installation

Add `rs_twitter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rs_twitter, "~> 0.1.0"}
  ]
end
```

**Documentation**

Browse documentation in [Hex]()


