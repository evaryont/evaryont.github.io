---
title: "Fixing Fakeweb & Coveralls conflict"
date: 2014-04-11 23:55 MST
tags: ruby, testing, troubleshooting
---

If you've started using Fakeweb to mock HTTP requests but at the same time you
have stopped getting coverage reports from Coveralls, you may have inadvertently
blocked the coveralls client from reporting.

If you look at the results from your CI, like Travis, you'll probably see the
following:

```
[Coveralls] Submitting to https://coveralls.io/api/v1
Coveralls encountered an exception: FakeWeb::NetConnectNotAllowedError
Real HTTP connections are disabled. Unregistered request: POST https://coveralls.io/api/v1/jobs
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/fakeweb-1.3.0/lib/fake_web/ext/net_http.rb:53:in `request_with_fakeweb'`
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/rest-client-1.6.7/lib/restclient/request.rb:176:in `block in transmit'
/home/travis/.rvm/rubies/ruby-2.0.0-p353/lib/ruby/2.0.0/net/http.rb:852:in `start'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/rest-client-1.6.7/lib/restclient/request.rb:172:in `transmit'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/rest-client-1.6.7/lib/restclient/request.rb:64:in `execute'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/rest-client-1.6.7/lib/restclient/request.rb:33:in `execute'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/rest-client-1.6.7/lib/restclient.rb:72:in `post'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/coveralls-0.7.0/lib/coveralls/api.rb:18:in `post_json'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/coveralls-0.7.0/lib/coveralls/simplecov.rb:72:in `format'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/simplecov-0.8.2/lib/simplecov/result.rb:46:in `format!'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/simplecov-0.8.2/lib/simplecov/configuration.rb:139:in `block in at_exit'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/simplecov-0.8.2/lib/simplecov/defaults.rb:54:in `call'
/home/travis/.rvm/gems/ruby-2.0.0-p353/gems/simplecov-0.8.2/lib/simplecov/defaults.rb:54:in `block in <top (required)>''`
```

The fix is really simple. You need to tell Fakeweb to allow requests to
coveralls.io. Fakeweb supports providing a regex to whitelist outgoing
connections:

```ruby
# in your spec_helper.rb
FakeWeb.allow_net_connect = %r[^https?://coveralls.io]
```
