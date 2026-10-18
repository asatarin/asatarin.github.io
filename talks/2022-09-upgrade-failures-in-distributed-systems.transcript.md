{% comment %}
Draft transcript https://docs.google.com/document/d/1O0c6yd6KVJhPqIZOWQQ8gjNmKEE0PMjp_jbdJ32L7uM/edit#
{% endcomment %}

#### Introduction

{% include timecode.html time="0:05" %}
Hello everyone, my name is Andrey Satarin, and I'm going to be talking about the paper "Understanding and Detecting
Software Upgrade Failures in Distributed Systems."

{% include timecode.html time="0:16" %}
So let's go. A rough outline of the talk: I'm going to give an introduction to the paper, talk about findings they have
on severity and root causes of upgrade failures, discuss testing and detecting those failures, some conclusions, and in
the end, I'm going to give some personal experience of me doing upgrade testing for a distributed system.

{% include timecode.html time="0:42" %}
Let's start with the introduction. What are upgrade failures? In the paper, they describe them as failures that occur
during an upgrade. So, it's not some configuration change; it's not a bug in the new version of the software you just
deployed. It's specifically the bug between interacting with two versions of software during the upgrade and nothing
else.

{% include timecode.html time="1:02" %}
So, why are they important? They looked at several distributed systems, and overall, the important aspects of those
failures were that they are large-scale because they touch either a large part of the system or the whole system.
Upgrades usually move pretty quickly through the system, so any bugs in there are impacting the entire system.

{% include timecode.html time="1:25" %}
The upgrade itself is a disruption to the system's normal operations, which may put it in a vulnerable state. The impact
of the bugs during the upgrade could be persistent, so you can corrupt your data, and you need to do something about it
later, which kind of costs you. Overall, those are hard to expose in-house. There's probably a little focus on testing
for those upgrade failures for distributed systems in general.

{% include timecode.html time="1:49" %}
So, what did they look at? They looked at symptoms and severity of upgrade failures, root causes, or the conditions that
trigger them, and why they are even happening. The final goal is basically how to detect those failures in distributed
systems and prevent them from happening in production.

{% include timecode.html time="2:08" %}
These are the systems they analyzed, and these are the bugs they looked at from their bug trackers of the corresponding
systems. Overall, it's about 100 bugs, more than that even, and this is where all the findings come from, just
basically, I assume, from reading and analyzing those bugs.

#### Findings on Severity and Root Causes

{% include timecode.html time="2:28" %}
Let's talk about the findings they have on severity, root causes, and some other aspects of those failures. First of
all, these are significantly higher priority than usual failures. So, if you take a population of all the bugs in your
system, the percentage of high-priority bugs will be lower than specifically for upgrade failures. That again
corresponds to their importance and kind of implies that we need to invest more in those.

{% include timecode.html time="2:55" %}
The majority of those failures are catastrophic, so it's either impacting the entire cluster or leads to catastrophic
data loss or maybe even performance degradation. And that's again compared to the general population of bugs; it is a
much higher percentage.

{% include timecode.html time="3:10" %}
Those bugs during upgrades are easy to observe. It doesn't mean they're easy to find. It just means if you can drive the
system into that behavior with a workload, you will observe some things like crashes or fatal exceptions or the whole
cluster unavailability, which is kind of hard to miss in tests, as long as you can actually have the workload and can
drive the system into that behavior.

{% include timecode.html time="3:40" %}
And even though they're easy to observe, 63% of them are not caught before the release. So, the whole premise of the
paper is that we need to get better at testing for those upgrades, and we need to come up with some other solutions to
find those before they make it to release, which the authors are working towards.

{% include timecode.html time="4:00" %}
About two-thirds of those upgrade failures are caused by data syntax or semantics, and those are roughly split 6 to
4 between persistent data and network messages. And two-thirds of those are pure syntax, and one-third is semantic
difference. So even though the syntax of the data is the same, it's just interpreted differently between different
versions.

{% include timecode.html time="4:22" %}
That comes later when they try to address those issues.

{% include timecode.html time="4:31" %}
So some of the percentage of those syntax incompatibilities are coming from serialization libraries, like Protobuf or
Thrift, where you just describe the message in a special language, and that means you can automatically detect those
incompatibilities versus trying to build some kind of a solution for every way to serialize. So that makes it easier to
scale in terms of, like, if you build solutions for Protobuf or Thrift, you can apply it to a lot of different systems.

{% include timecode.html time="5:03" %}
Which they did, and later talked about that.

{% include timecode.html time="5:07" %}
In general, out of all the upgrade failures they looked at, none of them require more than three nodes.
So three nodes are enough to trigger all the upgrade failures in all the systems they looked at.

{% include timecode.html time="5:22" %}
And that corresponds to some other finding from a paper on general defects in distributed systems, which is called "Simple
testing can prevent most critical failures." Pretty well-known paper from 2014, where they found that 98% of all the
failures in distributed systems are guaranteed to be observed in no more than three nodes.

{% include timecode.html time="5:46" %}
So that's an important result and kind of makes it easier for us to test. We don't need large clusters or anything like
that.

{% include timecode.html time="5:51" %}
Almost all of those upgrade failures are deterministic, so you don't need to find any kind of special data races or timing
conditions and things like that. If you can drive the system into that behavior with the workload, you can observe those
with pretty high confidence.

#### Testing and Detecting

{% include timecode.html time="6:10" %}
So the next part of the paper is kind of testing and detecting how current systems approach the testing for upgrade
failures and how authors propose to do that in a more systematic way.

{% include timecode.html time="6:25" %}
So the limitations in the state of the art of the systems they looked at, they noticed that there's a problem with
workload generation. Every time someone tries to test for upgrades, they design a workload from scratch; they don't
reuse it from somewhere else.

{% include timecode.html time="6:40" %}
That's kind of bad because you're trying to come up with a new workload. That means you're either doing it twice or not
exposing the system to a variety of workloads during the upgrade.

{% include timecode.html time="6:52" %}
Also, they noticed that there is no mechanism to systematically explore the whole space of upgrades, which includes
different versions, different configurations, and different update scenarios, like either stopping a full-stop upgrade
or rolling upgrade. So those are not exposed in a systematic way.

#### DUPTester

{% include timecode.html time="7:10" %}
And their proposed solution is two tools. First of those tools is DUPTester. So DUPTester is a distributed system
upgrade tester.

{% include timecode.html time="7:23" %}
The way it works is it simulates a three-node cluster, as one of the findings mentioned, you just need three nodes. And
systematically, it has three scenarios like full-stop upgrade, rolling upgrade, and adding a new node to the system.

{% include timecode.html time="7:44" %}
As I mentioned before, the workload challenge, and they mentioned that in the paper specifically, the main challenge is
the workload challenge.

{% include timecode.html time="7:52" %}
So the way DUPTester works with this challenge is they have two approaches.

{% include timecode.html time="7:58" %}
First of all is reusing stress tests, and that's relatively straightforward. You just run your system and DUPTester
in a containerized environment across three nodes, and you run your stress test against that system while DUPTester
exercises upgrades in a systematic way.

{% include timecode.html time="8:12" %}
And you look for all those crashes or catastrophic failures and things like that, which are hard to miss.

{% include timecode.html time="8:21" %}
The other approach is using unit tests, and there are some tricks that I'm going to be talking about in a second. So,
what's with the unit tests?

{% include timecode.html time="8:32" %}
The way they propose to reuse unit tests in DUPTester is by having two strategies.

{% include timecode.html time="8:39" %}
First of all, automatically translate the unit tests into client-side scripts. So if you have some tests, this is kind
of like why I put unit testing in quotes, because to me, that heavily implies that those unit tests are not actually
unit tests. The tests exercise the system at a pretty high level, very close to its public API or external API, and this
is why you can translate them into client-side scripts.

{% include timecode.html time="9:05" %}
So they're more like integration or end-to-end tests, if you will.

{% include timecode.html time="9:10" %}
The example they give is a standard unit test where it exercises some operations, and you can translate them. In their
case, in DUPTester, it's Python, so they actually translate Java into Python, making those tests in Python.

{% include timecode.html time="9:27" %}
So there are no guarantees to translate all of your unit tests, and it needs help from developers to map those
functions, including an internal API to external API, and also functions from basically Java into Python.

{% include timecode.html time="9:43" %}
Another strategy is to execute unit tests on version one of the software and then try to start it on version two, which
to me also implies they're not exactly unit tests because first of all, it persists data, and also they expose, again,
they work at some kind of API where that system actually makes sense and not some internal things which are not
translatable and not guaranteed between the versions.

#### DUPChecker

{% include timecode.html time="10:10" %}
The next tool they talk about is DUPChecker, which is targeting specifically the syntax of data across serialization
libraries and enum types.

{% include timecode.html time="10:22" %}
So DUPChecker targets two types of syntax incompatibilities in the system, specifically syntax, not semantics, of the
data, and just two types, but those turn out to be enough to cover a lot of ground.

{% include timecode.html time="10:42" %}
First of all, serialization libraries. They try to compare serialization syntax definitions of your data across
different versions, and they're all open-source alternatives.

{% include timecode.html time="10:54" %}
The other, a little bit more elaborate approach, is enum typed data, which I'll talk about in a second.

{% include timecode.html time="11:04" %}
For serialization libraries, for example, for Protobuf, they basically parse Protobuf definitions across two versions
and have a set of rules to check that those definitions between two versions do not have any incompatibilities.

{% include timecode.html time="11:19" %}
For example, adding or removing a required field in one of the versions will cause a system to exhibit failure during an
upgrade if that code actually gets executed, so they find those and report them as bugs.

{% include timecode.html time="11:34" %}
With enums, it's a little more elaborate. They actually use data flow analysis across the program to find enums which
get persisted. In this case, that's for Java, and in this particular case, they mention it for Java and for a specific
API to write Java data.

{% include timecode.html time="11:51" %}
And then, if there are any additions or deletions to those enums and the index of the enum gets persisted — so not just
a string representation, but the index of the enum itself — and all those things they can find from data flow analysis.

{% include timecode.html time="12:06" %}
If both of those conditions are true, they again report it as an error to developers. This covers enums specifically.

#### Conclusions

{% include timecode.html time="12:15" %}
So overall conclusions from the paper. First of all, this is the first in-depth analysis as far as the authors are
aware, and as far as I'm aware, of upgrade failures in distributed systems. And they found that those failures have severe
consequences compared to general bug population.

{% include timecode.html time="12:37" %}
They developed the DUPTester tool and found 20 new upgrade failures in four systems, and DUPChecker found more than 800
incompatibilities across seven systems. Two of those systems confirmed that all of those incompatibilities are actually
bugs, but they don't provide the number of what the number was for those.

{% include timecode.html time="12:58" %}
Specifically, the Apache HBase team requested DUPChecker to be a part of their overall testing pipeline, so they want to
prevent those incompatibilities in the future.

#### Personal Experience and Commentary

{% include timecode.html time="13:09" %}
With that, I kind of want to transition from discussing the paper to my personal experience and commentary on the paper
about upgrade testing.

{% include timecode.html time="13:23" %}
First of all, they don't, I guess, talk a lot about correctness on the upgrade path, because reusing stress tests or
reusing unit tests where they say run it on version one and start it on version two does not imply that the results the
system returns in those scenarios actually get validated to be correct. Traditionally, stress tests don't have
correctness validation, because we imply that the system works correctly, and we're just interested in its performance.

{% include timecode.html time="13:57" %}
Correctness for distributed systems specifically implies correctness under failures in the testing scenario. It means
fault injection in the real world; it means nodes failing, networks failing, things like that.

{% include timecode.html time="14:09" %}
They also do not discuss a lot of rollback. They mentioned it like for one bug, but I think testing system upgrade
definitely implies testing rollback because that's the other aspect of running the system in production and operating it.
And that's kind of missing in that paper to me.

{% include timecode.html time="14:35" %}
Regarding correctness, if we look at the system as a black box with version one, all the nodes running and everything
working, the system exposes some set of invariants to its customers. But if we actually add version two and do an upgrade
— in this example, a rolling upgrade — that means the system looks different internally, but for an external observer,
the same invariants the system provides must still hold, and the system must guarantee those. An external observer
doesn't see the difference between versions; they don't know if you're deploying. At least modern systems don't put up
maintenance notices saying, "We're going to experience failures in the database" — that's not what systems strive to do
these days. So for an external observer, there is no difference.

{% include timecode.html time="15:48" %}
Basically, my point here is that invariants during upgrade and invariants during normal operation are exactly the
same. So it means you can actually reuse a correctness test you already have, presumably, for the system — like for
example Cassandra, where you have correctness tests which are Jepsen-like with fault injection. You can use the same
test to test the system as a black box, the way Jepsen does it.

{% include timecode.html time="16:03" %}
And you don't need to use stress tests.

{% include timecode.html time="16:05" %}
And those tests guarantee correctness; they also check for correct behavior during execution. So if your system returns
an incorrect result during an upgrade, not just crashes — not those 70% of easy-to-detect failures, but something more
subtle like returning an incorrect result — you can also detect those. Because you're using correctness validation and
also using fault injection, because this is what Jepsen likes to do.

{% include timecode.html time="16:36" %}
The other aspect I mentioned before is upgrade and rollback. In the real world, we do need to test both upgrade and
rollback, because rollback is an operation that might happen and arguably, those rollback tests are getting exercised
even less frequently, so it's more important to test them in adversarial conditions like with fault injection.

{% include timecode.html time="17:15" %}
And also, because we're talking specifically about upgrade bugs, that means the probability of exposing those bugs,
especially under fault injection where the whole scenario becomes even more probabilistic than before, we need to have
increased mixed-version time. Because that directly corresponds to how many bugs we can expose. The more we can keep the
system in the mixed-version situation where we have version one and version two — I'm talking specifically about the
rolling upgrade scenario, obviously, because a full-stop upgrade is less interesting — we need to maximize that mixed-version
time.

{% include timecode.html time="17:58" %}
So the way I previously did upgrade testing in practice was to have a basically infinite cycle of upgrades and rollbacks so
the system goes through all the states infinitely. Obviously in practice they're not infinite; you have some kind of
time budget like 24 hours or 48 hours or whatever your release cadence is. So you want to schedule those upgrades and
rollbacks in a way that maximizes time of upgrade and rollback where the system actually runs two versions
concurrently.

And as I mentioned before, you can use not just stress tests as the paper suggests, but also your correctness validation
tests with fault injection, because in the real world, failures in distributed systems do not stop when you do an
upgrade. They will happen, and you do need to exercise those code paths during an upgrade in both versions or mixed
versions. This is the cycle of upgrade and rollback where you test both upgrade and rollback operations between version
one and version two and correctness during that execution.

{% include timecode.html time="19:00" %}
So overall, that's kind of my additional conclusion number two, is that there's certainly value in the research and
ideas presented in the paper. I liked how they reuse stress tests, obviously. The findings are very valuable because
they give quantitative data about upgrade failures compared to all the other bugs in the system. But I think there are
additional ways where we can improve upgrade testing for distributed systems compared to what the authors propose, and I
think thinking of the system during upgrade as thinking of the system during normal operation is a valuable approach,
like treating it as a black box with invariants the way Jepsen does.

{% include timecode.html time="19:49" %}
With that, I thank you for your attention, and I'm open for discussion.

