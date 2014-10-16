---
title: "Generating a webpage screenshot in ruby"
date: 2014-10-15 17:17 MST
tags: ruby, screenshot
---

As I have spent the last hour and a half figuring out, generating a screenshot
of a website in Ruby is harder than it seems.

So first off, we'll need a browser's rendering engine. Preferably one that is
headless, so we'll go with PhantomJS. Make sure it's installed.

Then, we need a way to control PhantomJS, and I'm a fan of Watir so we'll use
that. To connect to PhantomJS, you also need the selenium webdriver gem. So your
gemfile would look like:

```ruby
gem 'watir'
gem 'watir-webdriver'
```

Then let's write the code to actually take the screenshot:

```ruby
browser = Watir::Browser.new :phantomjs
browser.goto("https://google.com")
browser.screenshot.save 'google.com.png'
```

However, if you try to run it, the result isn't what you'd expect from Google.
It has the old black navigation bar at the top. As it turns out, Google does UA
sniffing, so let's pretend to be Firefox instead:

```ruby
capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs('phantomjs.page.settings.userAgent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/33.0')

browser = Watir::Browser.new :phantomjs, :desired_capabilities => capabilities
```

So that should work for everything and every body now, right? Nope!

As it also turns out, PhantomJS includes it's own certificate store, and if it
doesn't recognize a site's SSL certificate, it'll error out, returning a
transparent image as the screenshot. (Cause hey, `about:blank` is actually
blank!) You can set the command line parameter `--ignore-ssl-errors=true` to
fix that. You can pass CLI parameters in via a capability. So modifying the
previous code...

```ruby
capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs('phantomjs.page.settings.userAgent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/33.0',
                                                                   'phantomjs.cli.args' => ['--ignore-ssl-errors=true'])
```

Now personally, I think the default resolution (400x300) of PhantomJS is a
little small. I personally like the screenshot to be a bit bigger, so let's
expand it:

```ruby
dimensions = Selenium::WebDriver::Dimension.new(1024, 768)
browser.driver.manage.window.size = dimensions
```

There you go! A side note, the dimensions just set the size of the viewport, the
website can of course scroll beyond that size. Taking a screenshot will capture
the entire page, not just what is visible in the viewport.

The complete code:

```ruby
require 'watir'
require 'watir-webdriver'

capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs('phantomjs.page.settings.userAgent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/33.0',
                                                                   'phantomjs.cli.args' => ['--ignore-ssl-errors=true'])

browser = Watir::Browser.new :phantomjs, :desired_capabilities => capabilities

dimensions = Selenium::WebDriver::Dimension.new(1024, 768)
browser.driver.manage.window.size = dimensions

browser.goto("https://google.com")

browser.screenshot.save 'google.com.png'
```
