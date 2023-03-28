---
title: Formal Methods at Amazon S3
description: Presentation on "Using Lightweight Formal Methods to Validate a Key-Value Storage Node in Amazon S3" paper for distributed systems reading group.
date: 2022-02-02
image: /assets/thumbnails/2022-02-formal-methods-at-amazon-s3.jpg
layout: talk
---

{% comment %}
Comments and feedback for the talk https://docs.google.com/document/d/1k0MLqGJOKMozLoWKEvPwXCzOiTRuMd9Orw9zT0eDpic/edit#
{% endcomment %}

This is a talk on "Using Lightweight Formal Methods to Validate a Key-Value Storage Node in Amazon S3" 
paper for distributed systems [reading group](http://charap.co/category/reading-group/) 
lead by [Aleksey Charapko](https://twitter.com/AlekseyCharapko). 

### Paper
"Using lightweight formal methods to validate a key-value storage node in Amazon S3" 
by James Bornholt, Rajeev Joshi, Vytautas Astrauskas, Brendan Cully, Bernhard Kragl, 
Seth Markle, Kyle Sauri, Drew Schleit, Grant Slatton, Serdar Tasiran, Jacob Van Geffen,
Andrew Warfield. Presented at [SOSP 2021](https://dl.acm.org/doi/abs/10.1145/3477132.3483540).

#### Paper Abstract
This paper reports our experience applying lightweight formal methods to validate the correctness 
of ShardStore, a new key-value storage node implementation for the Amazon S3 cloud object storage service. 
By "lightweight formal methods" we mean a pragmatic approach to verifying the correctness 
of a production storage node that is under ongoing feature development by a full-time engineering team. 
We do not aim to achieve full formal verification, but instead emphasize automation, usability, 
and the ability to continually ensure correctness as both software and its specification evolve over time. 
Our approach decomposes correctness into independent properties, each checked by the most appropriate tool, 
and develops executable reference models as specifications to be checked against the implementation. 
Our work has prevented 16 issues from reaching production, including subtle crash consistency and 
concurrency problems, and has been extended by non-formal-methods experts to check new 
features and properties as ShardStore has evolved.

[Download slides (PDF)](/assets/talks/2022-02-formal-methods-at-amazon-S3.pdf)

<div class="video-container">
<script defer class="speakerdeck-embed" data-id="3b0d36b7552f4643b240cc599491e25b" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div class="video-container">
<iframe src="https://www.youtube.com/embed/fAYNN2MmOvk" loading="lazy" frameborder="0" allowfullscreen></iframe>
</div>

### References
 - "Using lightweight formal methods to validate a key-value storage node in Amazon S3" 
[paper](https://dl.acm.org/doi/abs/10.1145/3477132.3483540)
 - [Reading Group. Using Lightweight Formal Methods to Validate a Key-Value Storage Node in Amazon S3](http://charap.co/reading-group-using-lightweight-formal-methods-to-validate-a-key-value-storage-node-in-amazon-s3/) blog post from [Aleksey Charapko](http://charap.co/about-me/) on the reading group meeting
 - [Testing Distributed Systems](/testing-distributed-systems/) — if you are interested 
in approaches to testing distributed systems, there is curated list I maintain
 - [Talk](https://youtu.be/YdxvOPenjWI) at SOSP 2021
 - [Blog post](http://muratbuffalo.blogspot.com/2021/10/using-lightweight-formal-methods-to.html) on the paper 
from [Murat Demirbas](https://twitter.com/muratdemirbas)

### Transcript

{% comment %}
Draft transcript https://docs.google.com/document/d/1EYTEZysRqwiSs4ehm-BGzF-17FOES2wacGikP22K7-c/edit#
{% endcomment %}

Please note that this AI-generated video transcript may contain inaccuracies or omissions. 
I encourage you to use it as a reference only and verify information with the original video if needed.

<hr>

0:05 Hello everyone, my name is Andrey Satarin.

0:07 I'm going to be talking about the paper using lightweight formal methods to validate a key value storage node in
Amazon S3.

0:16 So, let's start with a quick outline of the talk. Roughly follows the outline of the paper. I'm going to be
introducing the short store, talking about what they are actually validating in the storage system, and what kind of
properties they're looking for.

0:31 Different approaches and different lenses they look at validating, such as conformance checking, checking crash
consistency, checking concurrent executions, and some other properties they look at in the system. Overall experience
and lessons from that work.

0:50 S3 is like a key value object storage provided by Amazon suite, and the core of the S3 service are storage node
servers, which basically are servers storing the actual data apart from index and other control plane stuff. The shard
store is the new key value storage node which is slowly, as at the time of the paper publication, rolling out in
production to replace the previous version.

1:18 Overall, it's roughly a thousand forty thousand lines of code and Rust. It has a concurrent implementation and
responsible like it should provide crash consistency properties which complicates implementation and like that's the
goal of the kind of verifying that storage to check for those properties.

1:36 So like the other goals are basically API correctness, does API do whatever it's supposed to be doing? Do put,
split, do get return the results they should be returning? Crash consistency on disk is a big thing because the system
is responsible for that, and in the presence of crashes, we still want to have the data consistent and provide certain
guarantees.

2:01 Correctness of the execution because apart from API calls, there are also some background tasks executed
concurrently, like, for example, garbage collection, and the presence of those tasks should not well invalidate any of
the external guarantees this short store provides.

2:50 In terms of the stock short store, it's basically based on the large log structures merch tree. Data is stored in
chunks, chunks are stored in extents, and that's everything stored on disk obviously. So on the right, there is a
picture from the paper itself.

3:26 First of all, they look at the core properties which are consistency and durability. Other things like
performance and availability are important but not the focus of this work.

3:52 Other good properties to have in production like lack of undefined behaviors, bound checking, like system not
crashing, which are desirable in operations, but not the main focus.

4:07 One of the other goals is to have all the results of that outlived involvement of a formal method expert. So,
basically, they don't want to have a team of formal meta-experts supporting this forever. They want to hand it off to
the development team. So, this is why they go in with a lightweight approach to formal methods, apart from other reasons
I mentioned before.

4:29 So what about durability, like the main thing? Basically, they view it through three different lenses, split it
into three different lenses, which is kind of like a matrix 2x2 with sequential execution and concurrent execution and
the presence or absence of crashes. So, this gives us sequential crash-free execution covered in section four, or
sequential execution with crashes or concurrent and crash-free. Concurrent execution with crashes is specifically out of
scope of that paper, so they don't talk about that, but all the others are covered.

5:12 So, the kind of thing they use a lot of to check for those properties is a reference model, which is basically an
implementation of the same API as the short store provides in Rust, but way simplified. So, it's like 1% of the size of
the actual implementation, so it's several orders of magnitude simpler because it does not care about certain other
implementation details like failures, probably performance, other things.

5:55 That idea of using the reference model as a mock also helps to keep it up to date with the implementation because
if you need to implement a new API, basically you have to implement the new API in a mock in the reference model because
you want to use it in some other test as a mock.

6:14 For conformance checking, it's like the first step of providing durability, which is sequential execution with no
crashes. For that, they basically use property-based testing, which is, in a few words, it's like applying random
operations to the system and validating that it does not violate certain variants.

7:00 For some cases, to steer the whole thing into interesting states or interesting code, they do need to do argument
bias, so kind of like not provide those operations uniformly randomly but some kind of bias them towards more
interesting, more complicated operations to steer a system in interesting states. But they mention that only do this if
there's strong quantitative evidence for the benefit of that biasing because otherwise, you might bake certain
assumptions you have of the implementation into the system.

7:36 You need to kind of figure out how to do that either through argument bias, you know, some other uh ways.

7:43 The models also extended later for the with the failure injection and there are certain failures they extend to
which is a fail stop crash covered in the crash consistency part.

7:56 Disk IO errors which basically the way they do it is relax the model to allow like more to allow relaxed checking
against the model so like when this certain operation crashed we basically have a certain uh we have the check which
says like don't basically says don't compare the crashed operations to the reference model, and some things like
resource exhaustion is specifically out of scope for property-based testing because it's kind of hard to extend the
model to those accidental complexity of things without uh making it more complicated than it should be.

8:34 So crash consistency which is again this is like sequential execution with the presence of crashes so the test
system still controls every operation and still executes them sequentially but they're one of the some of the operations
are basically crashes and the crash consistency is the primary motivations of this effort because the systems crash and
you still want to provide durability guarantees in the presence of those crashes and that's kind of the main uh goal of
the short store in the S3 as a system because charts are actually responsible for storing data on disks.

9:09 So to talk about this we need to talk about a write path which basically includes three steps, first writing
chunk data to extend and then updating index entry and then updating metadata will LSM to do this to point to the new
index data.

9:26 Those three operations kind of uh presented as a dependency graph internally or at least in the model and the IOS
IO schedule is responsible for uh persisting those dependencies in the correct order which is basically the lower ones
and then the ones depend on that so like the dependencies only persisted if the previous dependency uh is already
persisted so in the paper they present this picture of the dependency graph of three put operations so on the bottom of
the picture there are rights to the chunks so shark data right written to the chunk and then on top of those operations
which depend on the rights which is up index update uh and then the LSM metadata update and like as you can see from the
picture some of those like got merged together so there's like one LSM3 metadata update for several puts even though
like obviously chunk data it's they have more chunk data updates internally so and the the whole complexity of IO
scheduler and correct providing correctness guarantees come from kind of that correctly persisting this dependency
graph.

10:41 So for validating that they're looking for two properties basically persistence if dependency is persistent uh
one of those like rectangles is persisted it should be visible after the crash so if it's persisted it's persistent
basically and the forward progress uh basically says like if we uh do proper non-crash shutdown in this case every
operation dependency must be persistent so basically operation can uh succeeded and we should see all of the dependency
persisted and the actual result of the operation so these are like the properties they check in the system in the
presence of crashes.

11:19 So for that they need to extend the property based reference model. The way they do it, the reference model and
test themselves is basically adding new operations to the alphabet or the operations available for property based tests.
Things like dirty reboot, index flash. So basically, because it's a sequential model and the test runner, all the test
itself controls every operation, you can execute those new operations and like to emulate things happening like after
doing certain things, you do a reboot or index flash and then see how it corresponds to the actual implementation.

11:59 They also tried to do more fine-grain crashes like the block level, so not at index level or like little quartz
grain things. But the outcome was that they didn't uncover any new bugs, and because the state space is vastly larger,
it's just way slower. So this is not the default for how they run tests because it just was not beneficial.

12:27 The third lens the way they look at durability is checking concurrent executions without any crashes. So there
are no crashes in this, and the main property they check here for is linearizability, and they use actual model check
model checking here apart from all the previous approaches which use property-based testing. This is more towards the
actual formal verification of the system, and for that, they use two model checkers. The Loom, the one as I understand
it, was already present, so it's like this some model taker from a Rust ecosystem and a shuttle model checker with
probabilistic algorithms, the one they implement that I assume specifically for that work.

13:38 They kind of both together provide the sound scalability trade-off so like you can validate the shorter
histories in Loom, making sure that they're correct, but like at a larger scale with more iterations, a longer histories
you have to do like a shuttle model checker, which does not provide a full guarantee but still explores the state space.

14:06 Other properties they looked at in the system which are also desirable is the absence of undefeated behavior.
For that, there are Rust ecosystem tools like Mirror Interpreter and some other Rust compiler dynamic tools which
basically help to avoid undefined behavior in the Rust code.

14:26 The other thing is serialization they looked at because like this thing stalks the network and serializes stuff.
So one of the things they used is a Crux symbolic execution engine, which is for instance also part of the Rust
ecosystem, and that helps to prove panic freedom of serialization code but on top of that, they also use fuzzing
extensively to kind of like the way fuzzing works with sterilization code to make sure that like there are no crashes on
desirable behaviors and stuff like that.

15:01 Uh, so what are the overall lessons from that work and experience?

15:07 So, they mentioned that the development of the reference model took roughly two people for nine months, and
those were formal method experts people who like experts in specific areas, formal methods. And later in the lifetime
of the system, at the time of the publication of the paper, non-experts, but I assume that these are still experts in a
short store but not formal method experts, contributed roughly 18% of the model code. So, there was some handing over
support of the model, for sure, from experts to the actual development team.

15:38 Benefits they said are like early detection, they mentioned several bugs, at least one or two, basically
discovered even before code review. So before anyone looked at the code, people were running tests locally and
discovered certain bugs. And the continuous integration, the validation system, so like because the model runs in the
tests and also used in mocks and other tasks, it kind of helps to keep it up to date with regards to API and some kind
of fine-grained details because if they diverge, you basically see it through tests if you run them continuously, and
that's also a great benefit. And the model is executable, so it's not like a model in some different code, they both -
the reference model and the implementation of both rust, so like I presume they live together somewhere in the source
code.

16:41 There are certainly some limitations to this approach. So there are some issues with evaluating the coverage for
property-based tasks. For example, they mentioned that one of the bugs they missed but should have found with this
approach is the bug where the system does not hit the internal cache because the I presume the data set of the test was
small relative to the cache size and the basic cache hit rate was always hundred percent, but the bug was hidden
somewhere where you don't hit the cache, and they fine-tune it with the bias changing the cache size to kind of uncover
more, like to make sure that in the future, they all cover bugs in there.

17:52 And the API surface of search start store is actually larger than the cover and assist in the tests because
there are certain APIs provided for the control plane or which are not covered for whatever reason in the reference
model. So not even all of the APIs are covered.

18:14 Yeah, with this, I have like a shameless plug. If you're interested in testing things like that, distributed
systems, and like storage systems, I have a list of the things different companies do, and it's like papers, blog posts,
videos. It's there, pretty comprehensive.

18:33 And that's the end of the talk.
