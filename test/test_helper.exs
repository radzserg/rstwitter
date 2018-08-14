ExUnit.start()

# define mocks
Mox.defmock(RsTwitter.Http.ClientMock, for: RsTwitter.Http.ClientSpec)
