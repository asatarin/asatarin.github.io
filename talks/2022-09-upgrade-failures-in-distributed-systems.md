---
title: Understanding Upgrade Failures in Distributed Systems
description: Talk on "Understanding and Detecting Software Upgrade Failures in Distributed Systems" paper for distributed systems reading group.
date: 2022-09-28
image: /assets/thumbnails/2022-09-upgrade-failures-in-distributed-systems.webp
layout: talk
---

{% comment %}
Notes and draft for the talk https://docs.google.com/document/d/1rrcea6jOsAuB3SeGcsEZwb_b2GTfMc7hXlIXRSGoCKc/edit#
{% endcomment %}

This is a talk on "Understanding and Detecting Software Upgrade Failures in Distributed Systems"
paper for distributed systems [reading group](http://charap.co/category/reading-group/)
lead by [Aleksey Charapko](https://twitter.com/AlekseyCharapko).

### Paper

"Understanding and Detecting Software Upgrade Failures in Distributed Systems"
by Yongle Zhang, Junwen Yang, Zhuqi Jin, Utsav Sethi, Kirk Rodrigues, Shan Lu, Ding Yuan.
Presented at [SOSP 2021](https://dl.acm.org/doi/10.1145/3477132.3483577).

#### Paper Abstract

Upgrade is one of the most disruptive yet unavoidable maintenance tasks that undermine
the availability of distributed systems. Any failure during an upgrade is catastrophic,
as it further extends the service disruption caused by the upgrade. The increasing
adoption of continuous deployment further increases the frequency and burden of the upgrade task.
In practice, upgrade failures have caused many of today's high-profile cloud outages.
Unfortunately, there has been little understanding of their characteristics.

This paper presents an in-depth study of 123 real-world upgrade failures that were
previously reported by users in 8 widely used distributed systems, shedding
lights on the severity, root causes, exposing conditions, and fix strategies of upgrade
failures. Guided by our study, we have designed a testing framework DUPTester
that revealed 20 previously unknown upgrade failures in 4 distributed systems,
and applied a series of static checkers DUPChecker that discovered
over 800 cross-version data-format incompatibilities that can lead to upgrade failures.
DUPChecker has been requested by HBase developers to be integrated into their toolchain.

[Download slides (PDF)](/assets/talks/2022-09-upgrade-failures-in-distributed-systems.pdf)

<div class="video-container">
<script defer class="speakerdeck-embed" data-id="5d8f859e5d5d4865b867d5e4b1b69f68" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div class="video-container">
<iframe id="player" src="https://www.youtube.com/embed/2ybZcLXbJp8?enablejsapi=1" loading="lazy" frameborder="0" allowfullscreen></iframe>
</div>

### References

- "Understanding and Detecting Software Upgrade Failures in Distributed
  Systems" [paper](https://dl.acm.org/doi/10.1145/3477132.3483577)
- [Video](https://youtu.be/29-isLcDtL0) from SOSP 2021
- [Reference respository](https://github.com/zlab-purdue/ds-upgrade) for the paper
- [DUPTester tool code](https://gitlab.dsrg.utoronto.ca/zhuqi/DUPTester)
- [DUPChecker tool code](https://github.com/jwjwyoung/DUPChecker)
- [Jepsen.io](https://jepsen.io/)
- "Simple Testing Can Prevent Most Critical
  Failures" [paper](https://www.usenix.org/conference/osdi14/technical-sessions/presentation/yuan)
- Curated list of resources on [testing distributed systems](/testing-distributed-systems/)

### Transcript

{% comment %}
Draft transcript https://docs.google.com/document/d/1O0c6yd6KVJhPqIZOWQQ8gjNmKEE0PMjp_jbdJ32L7uM/edit#
{% endcomment %}

Please note that this AI-generated video transcript may contain inaccuracies or omissions.
I encourage you to use it as a reference only and verify information with the original video if needed.

<hr>

<span class="timecode">0:05</span>
Hello everyone, my name is Andrey Satarin, and I'm going to be talking about the paper "Understanding and Detecting
Software Upgrade Failures in Distributed Systems."

<span class="timecode">0:16</span>
So let's go. A rough outline of the talk: I'm going to give an introduction to the paper, talk about findings they have
on severity and root causes of upgrade failures, discuss testing and detecting those failures, some conclusions, and in
the end, I'm going to give some personal experience of me doing upgrade testing for a distributed system.

<span class="timecode">0:42</span>
Let's start with the introduction. What are upgrade failures? In the paper, we describe them as failures that occur
during an upgrade. So, it's not some configuration change; it's not a bug in the new version of the software you just
deployed. It's specifically the bug between interacting with two versions of software during the upgrade and nothing
else.

<span class="timecode">1:02</span>
So, why are they important? They looked at several distributed systems, and overall, the important aspects of those
failures were that they are large-scale because they touch either a large part of the system or the whole system.
Upgrades usually move pretty quickly through the system, so any bugs in there are impacting the entire system.

<span class="timecode">1:25</span>
The upgrade itself is a disruption to the system's normal operations, which may put it in a vulnerable state. The impact
of the bugs during the upgrade could be persistent, so you can corrupt your data, and you need to do something about it
later, which kind of costs you. Overall, those are hard to expose in-house. There's probably a little focus on testing
for those upgrade failures for distributed systems in general.

<span class="timecode">1:49</span>
So, what did they look at? They looked at symptoms and severity of upgrade failures, root causes, or the conditions that
trigger them, and why they are even happening. The final goal is basically how to detect those failures in distributed
systems and prevent them from happening in production.

<span class="timecode">2:08</span>
These are the systems they analyzed, and these are the bugs they looked at from their bug trackers of the corresponding
systems. Overall, it's about 100 bugs, more than that even, and this is where all the findings come from, just
basically, I assume, from reading and analyzing those bugs.

<span class="timecode">2:28</span>
Let's talk about the findings they have on severity, root causes, and some other aspects of those failures. First of
all, these are significantly higher priority than usual failures. So, if you take a population of all the bugs in your
system, the percentage of high-priority bugs will be lower than specifically for upgrade failures. That again
corresponds to their importance and kind of implies that we need to invest more in those.

<span class="timecode">2:55</span>
The majority of those failures are catastrophic, so it's either impacting the entire cluster or leads to catastrophic
data loss or maybe even performance degradation. And that's again compared to the general population of bugs; it is a
much higher percentage.

<span class="timecode">3:10</span>
Those bugs during upgrades are easy to observe. It doesn't mean they're easy to find. It just means if you can drive the
system into that behavior with a workload, you will observe some things like crashes or fatal exceptions or the whole
cluster unavailability, which is kind of hard to miss in tests, as long as you can actually have the workload and can
drive the system into that behavior.

<span class="timecode">3:40</span>
And even though they're easy to observe, 63% of them are not caught before the release. So, the whole premise of the
paper is that we need to get better at testing for those upgrades, and we need to come up with some other solutions to
find those before they make it to release, which the authors are working towards

<span class="timecode">4:00</span>
About two-thirds of those are, uh, up retailers are caused by data syntax or semantics, and those are roughly split 6 to
4 between persistent data and network messages. And two-thirds of those are pure syntax, and one-third is semantic
difference. So even though the syntax of the data is the same, it's just interpreted differently between different
versions.

<span class="timecode">4:22</span>
That comes later when they try to address those issues.

<span class="timecode">4:31</span>
Uh, so some of the percentage of those syntax and compatibles are coming from serialization libraries, like Protobuf or
Thrift, where you just describe the message in a special language, and that means you can automatically detect those
incompatibilities versus trying to build some kind of a solution for every way to serialize. So that makes it easier to
scale in terms of, like, if you build solutions for Protobuf or Thrift, you can apply it to a lot of different systems.

<span class="timecode">5:03</span>
Which they did, and later talked about that.

<span class="timecode">5:07</span>
Uh, in general, or about on with all the upgraded errors you look at, only none of them require more than three nodes.
So three nodes are enough to trigger all the upgrade values in all the systems they looked at.

<span class="timecode">5:22</span>
And that corresponds to some other finding from a paper on general defects in the super system, which is called "Simple
testing can prevent most critical failures." Pretty well-known paper from 2014, where they found that 98% of all the
failures in distributed systems are guaranteed to be observed in no more than three nodes.

<span class="timecode">5:46</span>
So that's an important result and kind of makes it easier for us to test. We don't need large clusters or anything like
that.

<span class="timecode">5:51</span>
Uh, almost all of those upgrades are deterministic, so you don't need to find any kind of special databases or timing
conditions and things like that. If you can drive the system into that behavior with the workload, you can observe those
with pretty high confidence.

<span class="timecode">6:10</span>
So the next part of the paper is kind of testing and detecting how concurrent systems approach the testing for upgrade
failures and how authors propose to do that in a more systematic way.

<span class="timecode">6:25</span>
So the limitations in the state of the art of the systems they looked at, they noticed that there's a problem with
workload generation. Every time someone tries to test for upgrades, they design a workload from scratch; they don't
reuse it from somewhere else.

<span class="timecode">6:40</span>
That's kind of bad because you're trying to come up with a new workload. That means you're either doing it twice or not
exposing the system to a variety of workloads during the upgrade.

<span class="timecode">6:52</span>
Also, they noticed that there is no mechanism to systematically explore the whole space of upgrades, which includes
different versions, different configurations, and different update scenarios, like either stopping a full stop upgrade
or rolling upgrade. So those are not exposed in a systematic way.

<span class="timecode">7:10</span>
Uh, and their proposed solution is two tools. First of those tools is Dub tester. So Dub tester is a distributed system
upgrade tester.

<span class="timecode">7:23</span>
The way it works is it simulates a three-node cluster, as one of the findings mentioned, you just need three nodes. And
systematically, it has three scenarios like full stop upgrade, rolling upgrade, and adding a new node to the system.

<span class="timecode">7:44</span>
As I mentioned before, the workload challenge, and they mentioned that in the paper specifically, the main challenge is
the workload challenge.

<span class="timecode">7:52</span>
So the way the Dub tester works with this challenge is they have two approaches.

<span class="timecode">7:58</span>
First of all is we're using stress tests, and that's relatively straightforward. You just run your system and adopt
tester in the containers environment across three nodes, and you run your stress test against that system while adopted
through exercises upgrades in a systematic way.

<span class="timecode">8:12</span>
And you look for all those crashes or catastrophic failures and things like that, which are hard to miss.

<span class="timecode">8:21</span>
The other approach is using unit tests, and there are some tricks that I'm going to be talking about in a second. So,
what's with the unit tests?

<span class="timecode">8:32</span>
The way they propose to reuse unit tests in AdoptTester is by having two strategies.

<span class="timecode">8:39</span>
First of all, automatically translate the unit tests into client-side scripts. So if you have some tests, this is kind
of like why I put unit testing in quotes, because to me, that heavily implies that those unit tests are not actually
unit tests. The tests exercise the system at a pretty high level, very close to its public KPI or external API, and this
is why you can translate them into clients and scripts.

<span class="timecode">9:05</span>
So they're more like integration or end-to-end tests, if you will.

<span class="timecode">9:10</span>
The example they give is a standard unit test where it exercises some operations, and you can translate them. In their
case, in AdoptTester, it's Python, so they actually translate Java into Python, making those tests in Python.

<span class="timecode">9:27</span>
So there are no guarantees to translate all of your unit tests, and it needs help from developers to map those
functions, including an internal API to external API, and also functions from basically Java into Python.

<span class="timecode">9:43</span>
Another strategy is to execute unit tests on version one of the software and then try to start it on version two, which
to me also implies they're not exactly unit tests because first of all, it persists data, and also they expose, again,
they work at some kind of API where that system actually makes sense and not some internal things which are not
translatable and not guaranteed between the versions.

<span class="timecode">10:10</span>
The next tool they talk about is DubChecker, which is targeting specifically the syntax of data post-utilization
libraries and enum types.

<span class="timecode">10:22</span>
So DubChecker targets two types of syntax incompatibilities in the system, specifically syntax, not semantics, of the
data, and just two types, but those turn out to be enough to cover a lot of ground.

<span class="timecode">10:42</span>
First of all, serialization libraries. They try to compare serialization syntax definitions of your data across
different versions, and they're all open-source alternatives.

<span class="timecode">10:54</span>
The other, a little bit more elaborate approach, is enum typed data, which I'll talk about in a second.

<span class="timecode">11:04</span>
For serialization libraries, for example, for Protobuf, they basically parse Protobuf definitions across two versions
and have a set of rules to check that those definitions between two versions do not have any incompatibilities.

<span class="timecode">11:19</span>
For example, adding or removing a required field in one of the versions will cause a system to exhibit failure during an
upgrade if that code actually gets executed, so they find those and report them as bugs.

<span class="timecode">11:34</span>
With enums, it's a little more elaborate. They actually use data flow analysis across the program to find enums which
get persisted. In this case, that's for Java, and in this particular case, they mention it for Java and for a specific
API to write Java data.

<span class="timecode">11:51</span>
And then, if there are any additions or deletions to those enums and index, these are those enums that

<span class="timecode">11:59</span>
All the things they find for they can find from data.

<span class="timecode">12:03</span>
Flow analysis if that.

<span class="timecode">12:06</span>
Both those conditions are true, they again report it as error to developers. This covers enum specifically.

<span class="timecode">12:15</span>
So overall conclusions from the paper. First of all, this is the first in-depth analysis as long as like authors, uh,
aware and as I'm aware of upgrade failures in the service systems. And they found like that those figures have severe
consequences compared to general bug population.

<span class="timecode">12:37</span>
They developed the Dot Tester tool and found new 20 new upgrade failures in four systems, and Dub Checker found around
800 more than 800 incompatibilities across seven systems. Two of those systems confirmed that all of those
incompatibility is actually bugs, but they don't provide the number of what the number was for those.

<span class="timecode">12:58</span>
Specifically, Apache hbased team requested Double Checker to be a part of their overall testing pipeline so they want to
prevent those incompatibilities in the future.

<span class="timecode">13:09</span>
With that, I kind of want to transition from discussing the paper to my personal experience and commentary in the paper
about upgrade testing.

<span class="timecode">13:23</span>
First of all, they don't like I guess talk a lot about correctness on the upgrade path because we're using stress tests
or region unit tests where they say run it on version one and started on version two does not imply that the results
they the system returns enough scenarios actually get validated that they're correct. So traditionally stress tests
don't have correct installation, so as long because we imply that the system works correctly, we just want to, we're
interested in its performance.

<span class="timecode">13:57</span>
All the correctness for distributed systems specifically implies correctness with failures in the testing scenario. It
means field injection in the real world, it means nodes failing, networks failing, things like that.

<span class="timecode">14:09</span>
They also do not discuss a lot of rollback. They mentioned it like for one bug, but I think testing system upgrade
definitely implies testing rollback because that's the other aspect of rolling like working the system actually in
production and operating it. And that's kind of to me it's missing in that paper.

<span class="timecode">14:35</span>
Regarding correctness, if we look at the system as a black box with version one in there, all the nodes running, and
everything happening, everything working, the system exposes some side of invariance to its customer and there's no
break. But if we actually add version two and do an upgrade, so this is like in this example who's going to be a rolling
upgrade, that means the system's kind of looking differently internally but for external observant, those in the same
invariants system provides, they still hold, and the system must guarantee those. Otherwise, because for external
Observer they don't see the difference between this version and this version, they don't know if you're deploying. At
least like modern systems and do that you don't put maintenance notice saying like we're going to have we're going to
experience failures in the database, that's not what systems strive to do these days. So for external Observer, there is
no difference.

<span class="timecode">15:48</span>
Basically, my point here is that invariants during upgrade and invariance during the normal operation are exactly the
same. So it means you can actually reuse a correctness test you already have presumably for the system, like for example
Cassandra, where you have correctness tests which are jobs and like with fault injection, you can use the same test to
test the system as a black box. So the way Jepsen does it.

<span class="timecode">16:03</span>
And you don't need to use stress tests.

<span class="timecode">16:05</span>
And those tests guarantee correctness, that's also a guarantee that they also check for correctness behavior during
execution. So if your system returns an incorrect result, do an upgrade not just crashes, not those 70% of easy to
detect failures, but something more subtle like returning correct result, you can also detect those. Because you're
using correctness, which actually validates those and also using fault injection, because this is what Jobson likes to
do.

<span class="timecode">16:36</span>
The other aspect I mentioned before is upgrade and rollback, so we do need to in real world we do need to test both
upgrade and rollback because rollback is an operation that might happen and arguably, those rollback tasks are getting
exercises even less frequently, so it's more important to test them in some kind of adversarial conditions like with
failure injections.

<span class="timecode">17:15</span>
And also, because we're talking specifically about upgrade bugs, that means the probability of exposing those bugs,
especially on the field injection, where the whole scenario becomes even more probabilistic than before, we need to have
increased mixed version time. Because that directly corresponds to how many bugs we can expose. The more we can keep the
system in the mixed diversion situation where we have version one and version two, I'm talking specifically about the
rollback rolling upgrades scenario, obviously because full stop upgrade is less interesting. So, we need to maximize
that mixed version time.

<span class="timecode">17:58</span>
So the way I previously did upgrade testing in practice was have a basically infinite cycle of upgrades and rollbacks so
the system goes through all the states infinitely, obviously in practice they're not internet, you have some kind of
time budget like 24 hours or 48 hours or whatever your release cadence is, things like that, and these are the most
important States in this. So you want to schedule those upgrades and rolling upgrades in a way that maximizes time of
upgrade and rollback where the system actually run into versions concurrently.

<span class="timecode">19:00</span>
Um, so overall, that's kind of my additional conclusion number two, is that there's certainly value in it, research and
ideas presented in the paper. I liked how they reuse stress tests, obviously. The findings are very valuable because
they give quantitative data about upgrade failures compared to all the other bugs in the system. But I think there are
additional ways where we can improve upgrade testing for distributed system versus compared to what they authors
propose, and I think thinking of the system during upgrade as thinking of the system during normal operation is the
valuable approach, like treating as a black box with invariance the way Japan does is a valuable approach to testing,
which is like a basically well-known thing as a black box testing in approach. Um, we wet with that.

<span class="timecode">19:49</span>
I thank you for your attention and I'm up for the discussion.

{% include transcript-code.html %}