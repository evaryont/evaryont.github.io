---
title: "Reset erchef admin password"
date: 2014-06-04 15:08 MST
tags:
---

![Chef Inc, logo](https://www.chef.io/images/logo.svg)

Forgetting the admin password to the self-hosted chef server can be a real pain.
Assuming you are using the [omnibus install of
chef-server](https://downloads.chef.io/chef-server/), you can reset the admin
password by logging into the server it's running on via SSH and run:

    sudo -u opscode-pgsql /opt/chef-server/embedded/bin/psql opscode_chef -f /tmp/reset.sql

Where `/tmp/reset.sql` contains the following:

    update osc_users set hashed_password='$2a$12$y31Wno2MKiGXS3FSgVg5UunKG48gJz0pRV//RMy1osDxVbrb0On4W', salt='$2a$12$y31Wno2MKiGXS3FSgVg5Uu' where username='admin';

Now you've reset the password, and can log in to the chef server admin page with
the user name 'admin' and password 'password'.
