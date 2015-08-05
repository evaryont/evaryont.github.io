---
title: "More about EC2 and NTP"
date: 2014-04-18 13:43 MST
tags:
---

There is a lot of back and forth about using NTP on Amazon's EC2 servers. Here
are some links:

* <http://serverfault.com/questions/100978/do-i-need-to-run-ntpd-in-my-ec2-instance>
* <http://www.metamul.com/blog/ntp-isnt-required-under-ec2-or-is-it/>
* <http://stackoverflow.com/questions/14623650/how-to-deal-with-the-amazon-ec2s-clock-drift>
* <http://james.lab6.com/2011/03/19/clock-drift-on-amazon-ec2/>
* <http://docs.basho.com/riak/latest/ops/tuning/aws/#Operating-System>
* <https://forums.aws.amazon.com/thread.jspa?messageID=364758>
* <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html>

A summary then:

Yeah, run NTP. It'll work 80% of the time. It won't work on some other EC2
servers (based on the instance type) but won't error out, a harmless no-op.
There is has been reported cases of NTP failing & erroring out when attempting
to set the time, but that also seems like a case of outdated kernels (either in
the Xen domU or on the guest). So update your VM and terminate/cycle it to
hopefully move it do a host Amazon server with the newer kernel.
