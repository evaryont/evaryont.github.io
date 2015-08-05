---
title: "Middleman: Error: Could not locate layout: layout"
date: 2014-03-18 18:39 MST
tags:
---

If you're getting the above as an error in your middleman site, however it's
only on articles from the blogging extension for Middleman, you may need to
update your `config.rb`.

If you specify a new name for the default layout in your config:

```ruby
set :layout, 'default'
```

Middleman will look for the layout called 'default' for each of your pages.
However, the blogging extension has it's own override in that you'll have to
specify in the activate block:

```ruby
activate :blog do |blog|
  blog.layout = "default"
end
```

That way the blogging extension doesn't use it's default layout name.
