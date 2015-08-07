---
title: "Generate a modern CSR with OpenSSL"
date: 2015-08-05 12:44 MST
tags: security
---

To get an SSL certificate, you need to first generate a CSR. However, some
early settings for the CSR can cripple your deployment before you even choose
any ciphers. The normal command, `openssl req`, will use old and now insecure
defaults.

Not that it's particularly hard, you just need to pass in some parameters to the
command to opt into the newer crypto:

    openssl req -nodes -new -newkey rsa:4096 -sha256 -keyout private.key -out cert.csr

The particular updates to the command are 2 part:

- The new certificate request will generate a 4096 bit RSA key. This is
  currently more than the base 2048 that's considered secure, but I have heard
  rumors about 2048 becoming factorizable... Better safe than sorry.
- Use SHA256 for the hash in the CSR.
  [Shaaaaaaaaaaaaa](https://shaaaaaaaaaaaaa.com/) has a good summary

For personal sites, not EVs, you can also pass another parameter to openssl to
avoid it asking questions. All you need for those sites is just the common name
of the certificate, or the domain name to be used for the site:

    openssl req -subj '/CN=evaryont.me/'
