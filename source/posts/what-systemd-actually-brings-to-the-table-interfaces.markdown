---
title: "What systemd actually brings to the table: Interfaces"
date: 2015-02-14 16:13 MST
tags: sysadmin
---

One thing I’d like point out is that while systemd is coupling many of those
sort of things together into one cohesive package (but not one program, natch),
it’s not trying to be the primary thing for all of those. So you can rule out
hostname, httpd, dbus, LUKS, date, and iptables from that list. (It won’t be
the primary webserver, it just has one. It isn’t hosting the DBus daemon as
part of it, it just uses it extensively, etc.)

The other aspect of some of the extraneous projects that systemd is introducing
(datetimed, hostnamed, etc) are just APIs and an implementation for something
that has badly needed one but nothing had arisen yet. Convention over
configuration is a powerful default, one that Linux has sorely lacked.

And there is a lot of configuration the system needs to do during boot-up to
get a basic functioning system, regardless of purpose. You want your hard
drives mounted, in the correct locations. You want your network stack
initialized, at least basically. You want your firewall rules applied. You want
all of this done in the correct order, but parallelized when possible. Which
means you’d need a defined interface to interrogate the state of each of those.
And perhaps a defined interface for each of those to notify the init process.
(An alternative architecture can be developed, I’m sure.)

All that being said, I think systemd would’ve been easier to swallow if
hostnamed, datetimed, etc were introduced earlier and used before pushing
systemd itself. However, I don’t think a lot of people would have used them
individually if they were. It’d be like looking at trying to replace a cron
implementation. A dedicated camp or two would use it, but the rest of the
community would ignore it. (Pick any example, I’m certain I could find examples
of alternatives coming but never reaching critical mind share. Even if they
would’ve improved the status quo in some way.)

I see systemd as pushing many different changes that needed to happen at some
point all at once. Risky, noisy, and quite painful. Ripping the bandages off
all the hacks from the 80’s & 90’s at once.

It could’ve been done better.

(In response to [this comment on Lobste.rs](https://lobste.rs/s/ewi8gu/fed_up_with_systemd_and_linux_why_not_try_pc-bsd/comments/7x7p9b#c_7x7p9b))
