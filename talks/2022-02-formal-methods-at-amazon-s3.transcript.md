{% comment %}
Draft transcript https://docs.google.com/document/d/1EYTEZysRqwiSs4ehm-BGzF-17FOES2wacGikP22K7-c/edit#
{% endcomment %}

#### Introduction

{% include timecode.html time="0:05" %}
Hello, everyone.

My name is Andrey Satarin.

I'm going to be talking about the paper using lightweight formal methods to validate key value storage not in Amazon S3.

So let's start.

The quick outline of the talk roughly follows the outline of the paper.

So I'm going to be introducing the shard store, talking about what they actually are validating in the storage system,
what kind of properties they're looking for, different approaches, and different lenses they look at, validating is,
which is conformance checking, checking crash consistency, checking concurrent executions, some of the properties they
looked at in the system, and overall experience and lessons from that work.

So introduction.

#### Introduction and ShardStore

{% include timecode.html time="0:50" %}
S3 is like a key value object storage provided by Amazon S3, and the core of S3 service are storage not servers, which
basically are servers storing the actual data apart from like index and other control plane stuff.

So the shard store is a new key value storage node, which is slowly at the time of the paper publication is rolling out
in production to replace the previous version.

Overall, it's roughly 40,000 lines of code in Rust.

It has concurrent implementation and responsible, like it should provide crash consistency properties, which complicates
implementation.

{% include timecode.html time="1:30" %}
And like that's the goal of the kind of verifying that storage to check for those properties.

So the other goals is basically API correctness, like does API does whatever it's supposed to be doing, puts
put and gets, return the results, they should be returning.

Crash consistency on disk is a big thing because system is responsible for that.

And in the presence of crashes, we still want to have the data consistent and providing certain guarantees, correctness
of the execution, because apart from API calls, there are also some background tasks executed concurrently, like for
example, garbage collection.

And the presence of those tasks should not invalidate any of the external guarantees this shard store provides.
Also, the goal is kind of have a soundness correctness trade off overall.
So they're not targeting full formal verification of the system and like proving that is absolutely correct.

They're willing to accept weaker guarantees at the expense of like using, but using more scalable methods, so like
larger histories or larger scale systems or bigger APIs, and things like that.

{% include timecode.html time="2:40" %}
So that's like, the idea is not to have like a fully verified storage, the idea is to have like some kind of trade
off between verifying correctness and having scalable way to verify it.

In terms of the shard store, it's basically based on the large log structures, merge tree, data is stored in chunks,
chunks are stored in extents, and that's everything is stored on disk, obviously.

So on the right, there is a picture from the paper itself.

So because shard store writes to several extents at the time, at the moment, it basically means that like there are more
than one write log and that complicates crash consistency.

{% include timecode.html time="3:20" %}
And as I mentioned before, there is a garbage collection and other internal processes also complicates things.
And the idea is to validate that.

#### Validating a Storage System

So what kind of properties?

What's their approach on validating this kind of system?
So first of all, they look at the core properties, which is consistency and durability.
Other things like performance and availability are all important, but not the focus of this work.
They'll have different ways to validate those and like test for decent performance and availability.
But the durability and consistency are the focus of this specific work.

Other good properties to have in production like lack of absence of undefined behaviors, bound checking, like system not
crashing, which are like desirable in operation.

{% include timecode.html time="4:04" %}
Also there, but not like the main focus.
So the other one of the other goals is to have all the results of that outlive involvement of a formal method expert.
So like basically, they don't want to have team of formal meta experts supporting this forever.
They want to like hand off it to the development team.
So this is why they go in with a lightweight approach to formal methods.
Part of the other reasons I mentioned before.

So what about durability?
Like the main thing, basically they view it through three different lens, like split it in three different lenses, which
is kind of like matrix two by two with sequential execution and concurrent execution and the presence or absence of
crashes.

So this gives us like sequential crash free execution covered in a section four or sequential execution with crashes or
concurrent and crash free.
Concurrent execution with crashes is specifically out of scope of that paper.
So they don't talk about that, but all the others are covered.

{% include timecode.html time="5:06" %}
So I'm just going to go through like sections of the go with the way they presented here.

So the kind of thing they use a lot of to check for those properties is a reference model, which is basically
implementation of the same API as a shard store provides in Rust, but way simplified.
So it's like 1% of the size of the actual implementation.
So it's like several orders of one simpler because it does not care about certain other implementation details like
failures, probably performance, other things.

And this reference model was used as a mock in other tests, like probably large scale tests where you don't need
storage, but you don't want to run the whole system, and you need something simpler to run in the test, not as large
scale.

That idea of using the reference model as a mock also helps to keep it up to date with implementation because if you
need to, if you implement a new API, basically you have to implement the new API in the mock in the reference model
because you want to use it in some other test as a mock.

#### Conformance Checking

{% include timecode.html time="6:10" %}
So conformance checking.

It's like the first step of providing durability, which is sequential execution with no crashes.
For that, they basically use property based testing, which is in a few words is like applying random operations to the
system and validating that it does not violate certain variants.

In this case, invariant is that like implementation refines the reference model.
So it doesn't do anything the model does not do.
And for some cases to steer the whole thing into interesting states or interesting code, they do need to do argument
bias.
So kind of like not provide those operations uniformly randomly, but like some kind of bias them towards more
interesting, more complicated operations to steer a system in interesting states.

But they mentioned that only do this if there's like strong quantitative evidence for the benefit of that biasing,
because otherwise you might bake certain assumptions you have of the implementation into the system.

{% include timecode.html time="07:17" %}
And that's kind of their idea of avoiding doing that to not bake assumptions in the test themselves, because that kind
of will be self-validating the system in a way, in a bad way.

Also, they use code coverage to look for those blind spots.

Like if some code is not covered by property based tests, you need to kind of figure out how to do that either through
argument bias, some other ways.

The model is also extended later with the failure injection.

And there are certain failures they extend to, which is a fail stop crash covered in the crash consistency part.

Disk I/O errors, which basically the way they do is relax the model to allow like more to allow relaxed checking
against the model.

So like when this certain operation crashed, we basically have a certain we have the check, which says like don't
basically says don't compare the crashed operations to the reference model.

{% include timecode.html time="8:17" %}
And some things like resource exhaustion is specifically out of scope for property based testing, because it's kind of
hard to extend the model to those accidental complexity things without making it more complicated than it should be.

#### Checking Crash Consistency

So crash consistency, which is again, it's like sequential execution with presence of crashes.
So the test system still controls every operation and still execute them sequentially.
But some operations are basically crashes.
And the crash consistency is the primary motivations of this effort, because like systems crash, and you still want to
provide durability guarantees in the presence of those crashes.

And that's kind of the main goal of the shard store in the S3 as a system, because shard store is actually responsible
for storing data on disks.

So to talk about this, we need to talk about write path, which basically includes three steps.
First writing chunk data to extend and then updating index entry, and then updating metadata over LSM to do this to
point to the index data.

{% include timecode.html time="9:24" %}
Those three operations kind of presented as a dependency graph internally, well, at least in the model.
And the IO schedule is responsible for persisting those dependencies in the correct order, which is basically the lower
ones and then the ones depend on that.

So like, the dependencies only persisted if the previous dependency is already persisted.
So in the paper, they present this picture of the dependency graph of three boot operations.
So on the bottom of the picture, there are writes to the chunks, so shard data written to the chunk.
And then on top of those operations, which depend on the writes, which is index update, and then the LSM metadata
update.
And like, as you can see from the picture, some of those got merged together.

So there's like one LSM tree metadata update for several puts, even though obviously chunk data, they have more chunk
data updates internally.

{% include timecode.html time="10:28" %}
So in the whole complexity of IO scheduler and providing correctness guarantees come from kind of that correctly
persisting this dependency graph.

So for validating that, they're looking for two properties, basically persistence.
If dependency is persistent, one of those rectangles is persisted.
It should be visible after the crash.
So if it's persisted, it's persisted basically.

And the forward progress basically says like, if we do proper non-crash shutdown, in this case, every operation
dependency must be persisted.
So basically, operations succeeded, and we should see all the dependency persisted and the actual result of the
operation.
So these are like the properties they check in the system in the presence of crashes.
So for that, they need to extend the property-based reference model.

{% include timecode.html time="11:25" %}
The way they do it, the reference model and test themselves is basically adding new operations to the alphabet or the
operations available for property-based tests, things like dirty reboot, index flush.

So basically, because it's again sequential model and the test runner, test itself controls every operation, you can
execute those new operations and emulate things happening.

So after doing certain things, you do reboot or index flush and then see how model corresponds to the actual
implementation.

They also tried to do more fine-grained crashes, like the block level.
So not at index level or coarse-grained things.
But the outcome was that they didn't cover any new bugs.
And because the state space is vastly larger, it's just way slower.
So this is not the default for how they run tests because it just was not beneficial.

#### Checking Concurrent Executions

For concurrent executions.
So basically, we covered sequential execution, sequential execution with crashes.

{% include timecode.html time="12:35" %}
The third lens, the way they look on durability, is the check-in concurrent executions with no crashes.
So there are no crashes in this.
And the main property they check here for is linearizability.
And they use actual model check-in here, apart from all the previous approaches, which use property-based testing.
This is more towards the actual formal verification of the system.

And for that, they use two model checkers, the loom, the one I understand was already present.
So there's some model checker from a Rust ecosystem.
And the shuttle model checker with probabilistic algorithms, the one they implemented, I assume specifically for that
work.
So there are handwritten harnesses to validate key properties as linearizability and durability, I guess.
Maybe just linearizability because there are no crashes.

And again, because loom is slower but provides soundness guarantees, but the shuttle is faster but does not provide such
a guarantee, they kind of both together provide the soundness scalability trade-off.

{% include timecode.html time="13:47" %}
So you can validate the sharder histories in loom, making sure that they're correct and sound.
But at the larger scale with more iterations, longer histories, you have to do like a shuttle model checker, which does
not provide a full guarantee but still explores the state space.

#### Other Properties

So other properties they looked at in the system, which are also desirable, is absence of undefined behavior.

For that, there is a Rust ecosystem tools like MIR interpreter and some other Rust compiler dynamic tools, which
basically help to avoid undefined behavior in the Rust code.
The other thing is serialization they looked at because this thing stalks the network and serializes stuff.
So one of the things they used is a Crux symbol execution engine, which is, for instance, also part of the Rust
ecosystem.

{% include timecode.html time="14:42" %}
And that helps to prove panic freedom of serialization code.
But on top of that, they also used fuzzing extensively to kind of like the way fuzzing works with serialization code to
make sure that there are no crashes on desirable behaviors and stuff like that.

#### Experience and Lessons

So what are the overall lessons from that work?
And experience.
So they mentioned that the development of the reference model to roughly two people for nine months, and those were a
formal method to experts, so people who like experts in specific area formal methods.

And later in the kind of lifetime of the system at the time of the publication of the paper, non-experts, but I assume
these are still experts in a shard store, but not formal method experts, contributed roughly 18% of the model code.
So there was some handing over support of the model, for sure, from experts to the actual development team.

{% include timecode.html time="15:50" %}
Benefits they cite are like early detection.
They mentioned several bugs, at least one or two, basically discovered even before code review.
So before anyone looked at the code, people were running tests locally and discovered certain bugs.
And the continuous integration validation system.

So because the model runs in a test and also used in a mock, in mocks and other tests, it kind of helps to keep it up to
date with regard to API and some kind of fine-grained details, because if they diverge, you basically see it through
tests if you run them continuously, and that's also a great benefit.

And the model is executable.
So it's not like a model in some different code.
The reference model and the implementation are both rust, so I presume they live together somewhere in the source code.
There are some limitations to this approach.
So there are some issues with evaluating the coverage for property-based tests.

For example, they mentioned that one of the bugs they missed but should have found with this approach is the bug where
basically the system does not hit the internal cache because I presume the dataset of the test was small relative to the
cache size, and basically cache hit rate was always 100%, but the bug was hidden somewhere where you don't hit the
cache, and they fine-tuned it with the bias, changing the cache size to kind of uncover more, or to make sure that in
the future they uncover bugs in there.

{% include timecode.html time="17:30" %}
There's also some kind of code which I think is fair to call accidental complexity of gluing shard store with S3, so
they mentioned routing and parsing S3 messages itself, and that's a pretty big chunk as far as I understand, and that's
not covered because it does not contribute to durability and consistency properties they were looking specifically for,
so that's kind of outside of that, but still important in actual production system.

And the EPI surface of shard store is actually larger than the cover in the tests because there are certain APIs
provided for control playing, or which are not covered for whatever reason in the reference model, so not even all
the APIs are covered.

{% include timecode.html time="18:20" %}
With this, I have a shameless plug.

If you're interested in testing things like that, distributed systems and storage systems have a list of the things
different companies do, and it's like papers, blog posts, videos, it's there, pretty comprehensive, and that's the end
of the talk.

{% include transcript-code.html %}
