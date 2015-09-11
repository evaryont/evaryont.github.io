---
title: "Setting up weechat relay behind nginx"
date: 2015-09-10 22:26 MST
tags: chat, irc, howto
---

Here's how to set up weechat with it's relay plugin sitting behind nginx. Why
not expose it directly? Well, and with all respect to the weechat developers, I
don't trust them enough to expose weechat directly onto the internet. And, I
already have nginx exposed on the firewall for this blog. It's already serving a
static HTML directory for my own local copy of [Glowing
Bear](http://www.glowing-bear.org/). So why not have nginx do one more thing and
proxy incoming WebSockets requests to weechat's relay? Setup was a bit
non-obvious so hopefully this will help out the next person along.

One feature I wanted to ensure was that the connection was encrypted end-to-end,
even between nginx and weechat. So the chain looks something like the following,
and every path between the components is encrypted with TLS:

```
User -> Nginx -> Weechat
```

Even though weechat will be configured with a self-signed certificate, the user
won't have to add a security exception since nginx will present a valid
certificate to the user, not weechat's self-signed certificate.

[csr]: http://evaryont.me/blog/2015/08/generate-a-modern-csr-with-openssl.html

## Configuring weechat

I'm assuming you already have HTTPS set up for nginx. If not, you may want to
look at my post on [how to make a CSR][csr] to get started on that. We will need
another certificate for weechat specifically so let's generate a self-signed
one:

    openssl req -x509 -nodes -newkey rsa:4096 -sha256 -keyout relay.key -out relay.pem -days 365 -subj '/CN=weechat relay/'

This will generate 2 files, `relay.key` (the private key) & `relay.pem` (the
public certificate). Save a copy of `relay.pem` elsewhere, it'll be used by
nginx to verify that it is actually talking to weechat.

Then you'll need to concatenate the two files into one for weechat's use,
starting the file with the private key followed by the public certificate:

    cat relay.key relay.pem > weechat.pem

Now we can enable the relay plugin and configure it to use the SSL key we have
just made (assuming you put the combined file into `~/.weechat/ssl`):

```
/set relay.network.password yourpassword
/set relay.network.ssl_cert_key "%h/ssl/weechat.pem"
/relay sslcertkey
/set relay.network.bind_address "::1"
/relay add ipv6.ssl.weechat 9001
```

*NB: I'm also configuring weechat to only listen on the IPv6 loopback interface.
If you don't want that, skip the last 2 lines.*

## Configuring nginx

Now that weechat is done, nginx is next! It's nice and simple, a fairly simple
nginx configuration like you've seen anywhere else. The important parts are the
map, upstream and location blocks.

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

# Make sure this upstream matches your configuration in weechat!
upstream weechat {
    server [::1]:9001;
}

server {
  listen 443;
  server_name irc.example.com;

  # certs sent to the client in SERVER HELLO are concatenated in ssl_certificate
  ssl_certificate /path/to/signed_cert_plus_intermediates;
  ssl_certificate_key /path/to/private_key;
  ssl_session_timeout 1d;
  ssl_session_cache shared:SSL:50m;

  # Diffie-Hellman parameter for DHE ciphersuites, recommended 2048 bits
  ssl_dhparam /path/to/dhparam.pem;

  # Mozilla modern TLS configuration. tweak to your needs.
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
  ssl_prefer_server_ciphers on;

  # HSTS (ngx_http_headers_module is required) (15768000 seconds = 6 months)
  add_header Strict-Transport-Security max-age=15768000;

  # OCSP Stapling ---
  # fetch OCSP records from URL in ssl_certificate and cache them
  ssl_stapling on;
  ssl_stapling_verify on;

  ## verify chain of trust of OCSP response using Root CA and Intermediate certs
  ssl_trusted_certificate /path/to/root_CA_cert_plus_intermediates;

  resolver <IP DNS resolver>;

  location /weechat {
      proxy_pass https://weechat;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_ssl_trusted_certificate /path/to/copy/of/relay.pem;
      proxy_ssl_verify off;
      proxy_read_timeout 4h;
  }

  location / {
    root /var/www/glowing-bear;
  }
}
```

[gb]: https://github.com/glowing-bear/glowing-bear/archive/gh-pages.zip

If download the [latest stable version of Glowing Bear][gb], extract it into the
directory `/var/www/glowing-bear` to have nginx serve it. This is entirely
optional, you can always use the public version.

## Finished!

Your connection settings for Glowing Bear, or any other relay client, would be
as follows:

* Host: **irc.example.com**
* Port: **443**
* Password: **yourpassword**
