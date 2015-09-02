---
title: "Announcing tls-grab"
date: 2015-08-28 17:49 MST
tags: announcement, software, security
---

It's surprisingly painful to script getting the public certificate a website
responds with. Or, getting the certificate's fingerprint. This information is
always mixed together with other human output, which means you'd have to resort
to mixing sed or grep and because the output is meant for humans not machines,
the regexes you'd make end up fragile.


So, I made [tls-grab][] to do the TLS handshake and get the server's public
certificate or to generate the certificate's fingerprint.

[tls-grab]: https://github.com/evaryont/tls-grab
