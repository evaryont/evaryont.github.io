---
title: "Modern IT looks really old"
date: 2015-09-17 20:53 MST
tags: sysadmin
---

This is my definition of what defines a modern IT stack. It's a lot of new king,
meet the old king stuff though — IT's duties haven't fundamentally changed,
just the way we go about doing them has. (Hello, containers!)

Inspired by [Joe Beda's post, Anatomy of a Modern Production Stack][amps], I
thought I would try restating everything he said. I'm focusing on slightly
smaller networks, or those that are very heterogeneous perhaps with a lot of
one-offs.  That is what I have most experience in: companies private IT not
global scale behemoths.

* **Production OS**: Like Joe said, Linux is pretty much the de-facto choice
for the underlying host you run on the bare metal. The applications might run
in a VM on top of it if you need a different OS (like Windows for AD, Exchange,
etc).

* **Application deployment source**: A repository. You might look to the future
and decide that you want to run a private Docker registry, or fall back on well
known tech like a distro's package repository. Or use a language's tools for
shipping your applications.  Rubygems certainly doesn't care if the gem it
downloads doesn't actually contain any Ruby in it.

* **Network management**: Assign IPs to your boxes. Starts with static IPs for
everything, or a personal DHCP server you're running. Gets a lot more complex
from there.

* **Configuration managment**: Once you boot a fresh machine, it needs to be fed in
information on how to properly join the network, any certificates or keys it
needs, etc. And of course, a name. Then it needs to be configured to actually
run the application you meant it to.

* **Discovery service**: Having IPs embedded in configuration files sucks and ends up
in practice as way to brittle. Especially if your machines can come & go with
radically different network properties (MAC/IP addresses for instance) but you
expect applications to be able to handle that. DNS is a common service, though
the caching behaviour of a lot of libraries would need to be tweaked first

* **Replicated storage**: It's almost guaranteed that you're going to want to
store the applications' data somewhere else other than right next to the
application itself within it's execution context (VM, container, etc). NFS
mounts, CIFS shares, and plenty of other technology. You might be able to avoid
this for a long time if every piece of data you write is going to be stored in a
purpose specific server, like a (No)SQL database.

* **Machine identity**: You can't rely on the edge of the network to be secure. A
perfectly secure firewall would let nothing by — but that would also mean
nothing can reach your applications! So if there must be a hole in the
firewall, that can possibly be exploited, how can your applications & machines
know who they are really talking to? Kerberos is a very common solution in this
space. There are still quite a bit of issues to deal with (what if the
application gets pwned and then steals your Kerberos TGT? You're in for a lot
of pain then.) before this can be called "solved" but bright minds are working
on it.

* **Monitoring**: You want to know when things go haywire, of course. The
next step beyond that is self healing services though. Most problems that
plague services are small. It's just not every day you get your entire network
broken into and exposed for the world. Most situations don't need that kind of
response and in fact could easily be done with one or two commands. Why not
make the computers do the boring repetitive stuff? A lot of people are scared
(and rightly so, a lot of stuff can go wrong with fail-overs) of overzealous
computers trying to solve imaginary problems, or using the wrong fix.

* **Centralized Logging**: I assume you already have competent logs. If you don't
then you need to fix that. Then you need to collate all of them across your
entire network. syslog is the old hat in this ring, ELK is a new contender (and
doing well at it!).

* **Debugging**: This is a really hard thing to generalize as the moment anyone
stops following the exact same steps as the rest of the world, all assumptions
are wrong. And of course every network is different, so developers could never
guess what your particular network would look like.  Whole system state capture
tools, like [Sysdig][], are one way to look at it.  Another is to start developing
an expansive library of configurable and highly specific tools, perhaps like
Mozilla's MIG.

* **Messaging**: Your applications certainly don't live in an island, so you'll
want to provide a way for them to talk to each other. This is as simple as each
application exposing a basic HTTP API all the way to a distributed, fault
tolerant message broker that every application connects to for publish &
subscribe events.

This is all the basic foundations for a modern IT stack that awfully looks (at a
    high level) much like every other IT stack. And that's really the crux of
it. If you want to start using Docker, you'll run into all of the above all over
again, but with slightly different parameters. It's even scarier to realize that
each of these categories has had so much work put in that you could easily make
a dissertation on just one.

So containers promise to change all of that by upending what we consider the
basic atoms of IT. I'm certain that I'll look back at this post and laugh;
things are greatly changing.  Then again, this is all just to keep the servers
running. *Has it really changed?*

[amps]: http://www.eightypercent.net/post/layers-in-the-stack.html
[Sysdig]: http://www.sysdig.org/
