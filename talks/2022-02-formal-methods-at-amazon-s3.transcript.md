{% comment %}
Draft transcript https://docs.google.com/document/d/1EYTEZysRqwiSs4ehm-BGzF-17FOES2wacGikP22K7-c/edit#
{% endcomment %}

#### Introduction

{% include timecode.html time="0:05" %}
Hello everyone, my name is Andrey Satarin.

{% include timecode.html time="0:07" %}
I'm going to be talking about the paper using lightweight formal methods to validate a key value storage node in
Amazon S3.

{% include timecode.html time="0:16" %}
So, let's start with a quick outline of the talk. Roughly follows the outline of the paper. I'm going to be
introducing the shard store, talking about what they are actually validating in the storage system, and what kind of
properties they're looking for.

{% include timecode.html time="0:31" %}
Different approaches and different lenses they look at validating, such as conformance checking, checking crash
consistency, checking concurrent executions, and some other properties they look at in the system. Overall experience
and lessons from that work.

#### Introduction and ShardStore

{% include timecode.html time="0:50" %}
S3 is like a key value object storage provided by Amazon S3, and the core of the S3 service are storage node
servers, which basically are servers storing the actual data apart from index and other control plane stuff. The shard
store is the new key value storage node which is slowly, as at the time of the paper publication, rolling out in
production to replace the previous version.

{% include timecode.html time="1:18" %}
Overall, it's roughly forty thousand lines of code in Rust. It has a concurrent implementation and
it should provide crash consistency properties which complicates implementation and that's the
goal of the kind of verifying that storage to check for those properties.

{% include timecode.html time="1:36" %}
The other goals are basically API correctness, does API do whatever it's supposed to be doing? Do puts
put, do get return the results they should be returning? Crash consistency on disk is a big thing because the system
is responsible for that, and in the presence of crashes, we still want to have the data consistent and provide certain
guarantees for correctness of the execution. 

{% include timecode.html time="2:01" %}
Because apart from API calls, there are also some background tasks executed
concurrently, for example, garbage collection, and the presence of those tasks should not invalidate any of
the external guarantees this shard store provides. 

{% include timecode.html time="2:17" %}
The goal is to have a soundness-correctness trade-off, meaning they're not targeting full formal verification of the 
system, but are willing to accept weaker guarantees at the expense of using more scalable methods.

{% include timecode.html time="2:50" %}
In terms of the shard store, it's basically based on the log structured merge tree. Data is stored in
chunks, chunks are stored in extents, and that's everything stored on disk, obviously. So on the right, there is a
picture from the paper itself.

{% include timecode.html time="3:01" %}
As the shard store writes to several extents at a time, it complicates crash consistency. And, as mentioned before, 
garbage collection and other internal processes also complicate things, and the idea is to validate that.

#### Validating a Storage System

{% include timecode.html time="3:26" %}
Their approach focuses on validating core properties such as consistency and durability. Other aspects like performance 
and availability are important but not the focus of this work. 
They have different ways to validate those and test for decent performance and availability, 
but the durability and consistency are the focus of this specific work.

{% include timecode.html time="3:52" %}
Other good properties to have in production — absence of undefined behaviors, bound checking, system
crashing, which are desirable in operation, but not the main focus.

{% include timecode.html time="4:07" %}
One of the other goals is to have all the results of that outlive involvement of a formal method expert.
Basically, they don't want to have a team of formal method experts supporting this forever. They want to hand it off to
the development team. This is why they go in with a lightweight approach to formal methods, apart from other reasons
I mentioned before.

{% include timecode.html time="4:29" %}
So what about durability, the main thing? Basically, they view it through three different lenses, split it
into three different lenses, which is kind of like a matrix 2x2 with sequential execution and concurrent execution and
the presence or absence of crashes. So, this gives us sequential crash-free execution covered in section four, or
sequential execution with crashes or concurrent and crash-free. Concurrent execution with crashes is specifically out of
scope of that paper, so they don't talk about that, but all the others are covered.

{% include timecode.html time="5:04" %}
I'm just going to go through sections the way they presented here.
So, the kind of thing they use a lot of to check for those properties is a reference model, which is basically an
implementation of the same API as the shard store provides in Rust, but way simplified. So, it's like 1% of the size of
the actual implementation, so it's several orders of magnitude simpler because it does not care about certain other
implementation details like failures, probably performance, other things.

{% include timecode.html time="5:39" %}
The reference model also used as a mock in other tests like probably large-scale tests where you don't need storage, 
but you don't want to run the whole system, and you need something simpler to run in the test, not as a large scale.

{% include timecode.html time="5:55" %}
That idea of using the reference model as a mock also helps to keep it up to date with the implementation because
if you need to implement a new API, basically you have to implement the new API in a mock in the reference model because
you want to use it in some other test as a mock.

#### Conformance Checking

{% include timecode.html time="6:14" %}
Conformance checking, it's the first step of providing durability, which is sequential execution with no
crashes. For that, they basically use property-based testing, which is, in a few words, it's like applying random
operations to the system and validating that it does not violate certain invariants. 
In this case, the invariant is that the implementation refines the reference model, so it doesn't do anything 
the model doesn't do.

{% include timecode.html time="7:00" %}
For some cases, to steer the whole thing into interesting states or interesting code, they do need to do argument
bias. Kind of like not provide those operations uniformly randomly but some kind of bias them towards more
interesting, more complicated operations to steer a system in interesting states. But they mention that only do this if
there's strong quantitative evidence for the benefit of that biasing because otherwise, you might bake certain
assumptions you have of the implementation into the system.

{% include timecode.html time="7:26" %}
Also, they use code coverage to look for those blind spots, like if some code is not covered by property-based tests.
You need to figure out how to do that either through argument bias or in some other ways.

{% include timecode.html time="7:43" %}
The models also extended later with the failure injection and there are certain failures they extend to
which is a fail stop crash covered in the crash consistency part.

{% include timecode.html time="7:56" %}
Disk IO errors which basically the way they do it is relaxing the model to allow relaxed checking
against the model. When this certain operation crashes we basically have a check which
says don't compare the crashed operations to the reference model. Some things like
resource exhaustion is specifically out of scope for property-based testing because it's hard to extend the
model to those accidental complexity things without making it more complicated than it should be.

#### Checking Crash Consistency

{% include timecode.html time="8:34" %}
So crash consistency which is again this is like sequential execution with the presence of crashes. The test
system still controls every operation and still executes them sequentially, but they're one of the some of the operations
are basically crashes. The crash consistency is the primary motivations of this effort because the systems crash and
you still want to provide durability guarantees in the presence of those crashes and that's kind of the main uh goal of
the short store in the S3 as a system because charts are actually responsible for storing data on disks.

{% include timecode.html time="9:09" %}
So to talk about this we need to talk about a write path, which basically includes three steps, first writing
chunk data to extend and then updating index entry and then updating metadata will LSM to do this to point to the new
index data.

{% include timecode.html time="9:26" %}
These three operations are presented as a dependency graph internally, at least in the model. The 
IO scheduler is responsible for persisting those dependencies in the correct order. Which is basically the lower ones
and then the ones that depend on them. The dependency only persisted if the previous dependency is already
persisted. In the paper they present this picture of the dependency graph of three put operations. On the bottom of
the picture there are rights to the chunks so shard data right written to the chunk. And then on top of those operations
which depend on the rights which is up index update uh and then the LSM metadata update. As you can see from the
picture, some of those like got merged together so there's like one LSM tree metadata update for several puts even though
like obviously chunk data it's they have more chunk data updates internally so and the the whole complexity of IO
scheduler and correct providing correctness guarantees come from kind of that correctly persisting this dependency
graph.

{% include timecode.html time="10:41" %}
So for validating that they're looking for two properties basically persistence if dependency is persistent, 
one of those like rectangles is persisted it should be visible after the crash so if it's persisted it's persistent
basically. 
And the forward progress — basically says if we do proper non-crash shutdown in this case every
operation dependency must be persistent. Operation can succeeded and we should see all of the dependency
persisted and the actual result of the operation so these are like the properties they check in the system in the
presence of crashes.

{% include timecode.html time="11:19" %}
So for that they need to extend the property based reference model. The way they do it, the reference model and
test themselves is basically adding new operations to the alphabet or the operations available for property based tests.
Things like dirty reboot, index flush. So basically, because it's a sequential model and the test runner, all the test
itself controls every operation, you can execute those new operations and emulate things happening after
doing certain things, you do a reboot or index flash and then see how it corresponds to the actual implementation.

{% include timecode.html time="11:59" %}
They also tried to do more fine-grain crashes like the block level, so not at index level or like little quartz
grain things. But the outcome was that they didn't uncover any new bugs, and because the state space is vastly larger,
it's just way slower. So this is not the default for how they run tests because it just was not beneficial.

#### Checking Concurrent Executions

{% include timecode.html time="12:27" %}
For concurrent executions, they cover sequential execution with and without crashes.
The third lens the way they look at durability is checking concurrent executions without any crashes. So there
are no crashes in this. And the main property they check here for is linearizability, and they use actual model check
model checking here apart from all the previous approaches which use property-based testing. This is more towards the
actual formal verification of the system, and for that, they use two model checkers. The Loom, the one as I understand
it, was already present, so it's like this some model checker from a Rust ecosystem and the Shuttle model checker with
probabilistic algorithms, the one that I assume they implemented specifically for that work.

{% include timecode.html time="13:19" %}
They use handwritten harnesses to validate key properties like linearizability. Loom is slower but provides soundness 
guarantees, while Shuttle is faster but doesn't provide such guarantees. 

{% include timecode.html time="13:38" %}
Together, they provide a sound scalability trade-off. You can validate the shorter
histories in Loom, making sure that they're correct and sound.
At a larger scale with more iterations, a longer histories
you have to do like a shuttle model checker, which does not provide a full guarantee but still explores the state space.

#### Other Properties

{% include timecode.html time="14:06" %}
Other properties they looked at in the system which are also desirable is the absence of undefined behavior.
For that, there are Rust ecosystem tools like Miri Interpreter and some other Rust compiler dynamic tools which
basically help to avoid undefined behavior in the Rust code.

{% include timecode.html time="14:26" %}
The other thing is serialization they looked at because like this thing stalks the network and serializes stuff.
So one of the things they used is a Crux symbolic execution engine, which is for instance also part of the Rust
ecosystem, and that helps to prove panic freedom of serialization code but on top of that, they also use fuzzing
extensively to kind of like the way fuzzing works with serilization code to make sure that like there are no crashes on
desirable behaviors and stuff like that.

#### Experience and Lessons

{% include timecode.html time="15:01" %}
Uh, so what are the overall lessons from that work and experience?

{% include timecode.html time="15:07" %}
So, they mentioned that the development of the reference model took roughly two people for nine months, and
those were formal method experts people who like experts in specific areas, formal methods. And later in the lifetime
of the system, at the time of the publication of the paper, non-experts, but I assume that these are still experts in a
short store but not formal method experts, contributed roughly 18% of the model code. So, there was some handing over
support of the model, for sure, from experts to the actual development team.

{% include timecode.html time="15:38" %}
Benefits they said are like early detection, they mentioned several bugs, at least one or two, basically
discovered even before code review. So before anyone looked at the code, people were running tests locally and
discovered certain bugs. And the continuous integration, the validation system, so like because the model runs in the
tests and also used in mocks and other tasks, it helps to keep it up to date with regards to API and some kind
of fine-grained details because if they diverge, you basically see it through tests if you run them continuously, and
that's also a great benefit. And the model is executable, so it's not like a model in some different code, they 
both — the reference model and the implementation are both in Rust, so like I presume they live together somewhere in the source
code.

{% include timecode.html time="16:41" %}
There are certainly some limitations to this approach. So there are some issues with evaluating the coverage for
property-based tasks. For example, they mentioned that one of the bugs they missed but should have found with this
approach is the bug where the system does not hit the internal cache because, I presume the data set of the test was
small relative to the cache size and the basic cache hit rate was always hundred percent. The bug was hidden
somewhere where you don't hit the cache, They fine-tuned it with the bias, changing the cache size to uncover
more, to make sure that in the future, they all cover bugs in there.

{% include timecode.html time="17:28" %}
There is also code that could be called "accidental complexity," which involves gluing the shard store with S3. 
They mentioned routing and parsing S3 messages, which is a significant portion of the code that isn't covered because 
it doesn't contribute to durability and consistency properties, they were looking for.
It is still important in the actual production system.

{% include timecode.html time="17:52" %}
And the API surface of search shard store is actually larger than the cover and assist in the tests because
there are certain APIs provided for the control plane or which are not covered for whatever reason in the reference
model. So not all of the APIs are covered.

{% include timecode.html time="18:14" %}
Yeah, with this, I have like a shameless plug. If you're interested in testing things like that, distributed
systems, and like storage systems, I have a list of the things different companies do, and it's like papers, blog posts,
videos. It's there, pretty comprehensive.

{% include timecode.html time="18:33" %}
And that's the end of the talk.

{% include transcript-code.html %}
