---
title: "Nginx may not reload config"
date: 2015-07-12 09:03 MST
tags: sysadmin
---

![Have you tried turning it off and on again?](https://www.thinkgeek.com/images/products/additional/large/11C3_ITCROWD_TURNOFFON.jpg)

Per the [nginx documentation](http://wiki.nginx.org/CommandLine)
(emphasis mine):

> What happens is that when nginx receives the HUP signal, it tries to parse the
> configuration file (the specified one, if present, otherwise the default), and
> if successful, tries to apply a new configuration (i.e. re-open the log files
> and listen sockets). If successful, nginx runs new worker processes and
> signals graceful shutdown to old workers. Notified workers close listen
> sockets but continue to serve current clients. After serving all clients old
> workers shutdown. **If nginx couldn't successfully apply the new configuration,
> it continues to work with an old configuration.**

Thus, if you have a properly set up nginx configuration and yet you are still
getting the default "Welcome to nginx!" page over and over, try restarting nginx
itself. I wished I'd have realized this aspect of nginx before spending hours
scratching my head.
