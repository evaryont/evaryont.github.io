---
title: "Reset erchef admin password"
date: 2014-06-04 15:08 MST
tags:
---

A quick note:

    sudo -u opscode-pgsql /opt/chef-server/embedded/bin/psql opscode_chef -f /tmp/reset.sql

Where `reset.sql` contains the following:

    update osc_users set hashed_password='$2a$12$y31Wno2MKiGXS3FSgVg5UunKG48gJz0pRV//RMy1osDxVbrb0On4W', salt='$2a$12$y31Wno2MKiGXS3FSgVg5Uu' where username='admin';

Now you can log in to the chef server admin page with the user name 'admin' and
password 'password'.
