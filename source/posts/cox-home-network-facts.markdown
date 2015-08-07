---
title: "Cox home network facts"
date: 2015-03-02 16:29 MST
tags: networking
---

Just called Tier 2 tech support for Cox looking to unblock some ports. Namely,
port 80, for web servers. Turns out that’s not going to happen.

The following ports are blocked for inbound traffic:

- 80
- 25
- 135-139
- 143
- 445
- 1433-1434
- 1900

(For a total of 13 ports that will never respond.)

The tech support on call seemed to imply that outbound traffic on port 25 is
blocked as well.

Also, static IPs for residental networks are never, ever going to happen.

Unblocking those ports? Nope, never. No if, ands, or buts about it. This is
entirely due to malware using those ports to either open an outgoing RAT/C&C
connection, or breach the network via exploits on software commonly run on
those ports (looking at you, intrepid Microsoft Server user who doesn’t know
how to secure it).

But notably, the default port for HTTPS (443) isn’t blocked, and I specifically
asked about it. Totally go for it, it’s fine. Of course, if you start hosting
malware and generally causing trouble for the neighboorhood, that’s no bueno
and is grounds for account termination. “No internet for you!” (The whole
neighboorhood can be affected because your bandwidth is shared up to the cable
node.)
