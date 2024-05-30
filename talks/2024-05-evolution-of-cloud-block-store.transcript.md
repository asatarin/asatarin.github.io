{% comment %}
Draft transcript https://docs.google.com/document/d/1wLbqJ_H0ts5_ntrsGlUamvwwNjS82aZx2k7L8Wi4LCA/edit
{% endcomment %}

#### Introduction

{% include timecode.html time="0:09" %}
Hello everybody, my name is Andrey Satarin and I'm going to be talking about this paper, “What's the story in EBS Glory:
Evolution and the Lessons Learning in Building Cloud Blockstore”.
This is a paper from Alibaba about their Cloud Blockstore.

#### Outline

So the rough outline, I'm going to be talking about the evolution of their service from version 1 to version 3 and
there's also EBSX, which is slightly different.
I'll talk about what that is.
Their discussion about elasticity in latency and throughput and how they address those challenges, challenges
availability, quite important for any cloud service out there and overall conclusions and references.

#### Cloud Block Store

So what is even the Cloud Blockstore also known as Elastic Blockstore?
This is basically a persistent virtual disk in the cloud.
So you cannot have a persistent disk in your virtual machine in the cloud because once the machine disappears, the data
disappears. So you have to come up with something else. And something else is the Cloud Blockstore or Elastic Block
Storage. You can attach it to a virtual machine.

{% include timecode.html time="1:18" %}
You can scale it at scale IOPS throughput capacity in a pretty wide range.

So you can have a small disk, you can have a larger disk, you can scale it up online without changing anything, without
reattaching hardware or anything like that because it's the cloud, all those things you do through API.

So that's roughly what we're talking about.
And this is a service like that from Alibaba Cloud, one of the big ones, Cloud, outside of EBS specifically.
The main focus of the, one of the main focuses of the paper is evolution of that service through years and how they
first started and how they addressed upcoming challenges.

#### EBS Architecture Evolution

{% include timecode.html time="1:49" %}
So they mentioned that EBS first version came out in 2012, so pretty old.
And that was based on a regular TCP protocol and was on a hard drive.
So spinning drives pretty slow, relatively speaking.

The next step in evolution was version two with Luna, their custom protocol for networking and based on SSDs, where one
of the features they introduced is background erasure coding and compression to address basically storage costs or
storage efficiency.

Next step is EBS3, as far as I think that's there, the latest step with additional features like foreground erasure
coding and compression.
So not only somewhere in the background, but also in the write path.
And I'm going to be talking about that.
They mentioned a feature called auto performance level, but I don't think they elaborate in the paper on what that
actually is.
So I'm not going to be talking about that at all.

They talk about the logical failure domain, which is their response to challenges of availability.
I'm going to be talking about that later.
And also they mentioned a slightly different version of EBS3, which is called EBSX, which is supposed to address
challenges in latency.

And the most recent feature they have is federated block manager, which is also to address availability challenges at
the control plane level for their service.
And I'm going to be talking about that later.

#### EBS1

{% include timecode.html time="3:18" %}
So what is evolution?
What did the first version look like?
And the first version, remember it's 2012, looked like this.
So on the left, you have your compute, your virtual machines, which interact with the service via a block client.
And VD is a virtual disk.
So you can have a bunch of virtual disks attached to a virtual machine.

And they talk through a block client, two sides on the right, which is going to be a storage cluster where there is a
block manager providing fault tolerance with Paxos.
And that basically maps your virtual disk into a block server.

And each virtual disk is managed by a single block server.
So you always go for a single server for your single virtual disk.
And further to the right is chunk services, which are basically storing the data.

Each sub data is stored three ways replicated.
I'm going to be talking about this a bit.
Yeah.
So it is replicated in three ways.
Yeah.

{% include timecode.html time="3:55" %}
So block manager Paxos maintains metadata about virtual disks.
So basically where you know your virtual disk, where the data is actually located for this.
So which chunk manager stores the data.

Block client connects to that and obviously caches those mappings because they don't change that often.
The data, everything is implemented on Paxos in their services, which we will import later because they will rip that
out.

Everything replicated three times and stored locally, basically in chunk servers in the ext4 file system with in-place
updates.
So you have for each 64 megabytes of data, you have a 64 megabyte file and you write to that file on chunk servers
basically to persist.

{% include timecode.html time="5:11" %}
And that has certain challenges in terms of limits.
First of all, you store data three times for replicating.
This is pretty big overhead long term.
There are limits in performance because as I said, every virtual disk basically goes through a single block server.
So you are bound by the performance of that block server.
If it's not performing enough, you cannot overtake that in terms of that bottleneck.
And there could be some hotspots because the block server is also not completely like you can have software from some
hotspots.

They also found that to guarantee any kind of SLO, it's hard to do with spinning hard drives and the kernel TCP/AP.
So they kind of do not like that architecture and that approach for those reasons.

#### EBS2

{% include timecode.html time="6:09" %}
And to address all of those, they basically come up with EBS2, which is speedup in terms of performance and improving
space efficiency.
These were the main goals for that rewrite of architecture, I guess.

So overview, the main changes, as I mentioned, to address the challenges of performance and space efficiency.
First of all, they do not handle persistence or consensus directly.
They develop on top of their distributed file system Pangu, which also has a leader election API.
So instead of having consensus, you just defer to Pangu, who is the leader now and do that.
They don't implement Paxos in their own services.
So basically they have like whatever, etcd/chubby zookeeper implemented in Pangu.

They also changed the lock structure design of their block servers.
So basically instead of having in place updates for rates, they turn them into a PANS and I'll talk about that later a
bit.

{% include timecode.html time="7:11" %}
So that kind of splits traffic in your front end traffic for client IO, where like client actually writes the writes and
that traffic originates from the client and the background, which is garbage collection and compression to turn out
those lock structured, like basically merge those lock structured, whatever, SS tables or whatever they call them.

So basically your logs into more read-optimized things.
And now they have failover at the granular of a segment instead of virtual disk.
They introduced this concept of a segment.

The cluster changes into a different architecture.
Now computers at the top and storage at the bottom as it should be.
So compute clusters, now each virtual disk has a concept of a segment and each block server manages one segment instead
of one virtual disk.

And there's also a block manager on the right where it knows which virtual disk segment corresponds to which block
server.
And also says block server management in terms of like blocks or fails, it reassigns its segments to other block servers
and things like that.

{% include timecode.html time="8:27" %}
And underneath that there's a file layer of the Pango distributed file system.
So we do not handle persistence ourselves.
So we just write to Pango and write up performed by this LSBD core, lock structured block device core which basically
turns writes into, turns in place updates into appends.

And on the file system side, we have two things, which is a replicated file, which is though those appends go into
initially, they are still three times replicated, but that just basically or write ahead log, quote unquote, because
these are writes turned to appends.

And then the garbage collection side or basically a merge side on the background turns those replicated files into
erasure coded data files, which are more space efficient.
So you don't store the same, basically if you write data over and over, you don't store all the copies, you store just
the most recent one and you also apply erasure coding and things like that, making it more storage optimized.

{% include timecode.html time="9:40" %}
So logically, they also split their disk into a lot of different things.
Like there's a segment group at the top.
So like your logical space of the disk, your gigabytes and terabytes of disks, a virtual disk space turns into segments,
segment groups, which turn into segments and those each segment is stored on each block server.

And this whole logical structure allows for more parallelism in the disk itself.
So write into different segments, segment groups or segments turns into rates into different block servers, which allows
for more parallelism.
And that is important for performance.

As I mentioned before, none of the blocks actually handle persistence. Persistence handled by the Pango distributed file
system.
So underneath that is also Pango.

{% include timecode.html time="10:30" %}
So what does the lock structure device look like?
This is basically the client writes or front end writes.
So they start turning those in place updates into appends in Pango.
And this is a replicated data file where each four kilobyte data piece has a header.

So the write request comes in, you write that data to Pango and acknowledge the write.
And then there are additional data structures to speed up recovery or moving block storage, block servers between moving
chunks between block servers.

So there's a transaction file and this whole SS table, lock structure from history, data structure to support basically
to know which logical offset corresponds to which file.
And similar to all the other lock structure storage engines.
So this is the front end part.

{% include timecode.html time="11:32" %}
The back end part is mostly garbage collection and some scrubbing they mentioned for correctness.
So basically making sure that there's no bitrot.
They briefly mentioned that as well.

So on the garbage collection side, you have a block client, which writes that data to the LSBD core in a block server,
which we write the REPLX into Pango with the replicated data file.
And then the garbage collection worker reads that back and stores a razor coded file again in Pango.
There's less data here because I guess this is not like a hard number.

This is what they calculated on average in the wild for their clusters, which basically means like there are a lot of
other writes on the same bytes and you can drop some of them.
But just some important information here is at this lower boundary here, you read and write 4.69 times and that is all
network amplification, which they very much want to avoid.

{% include timecode.html time="12:36" %}
So that's a pretty important number.
So like, as I mentioned, the network complication is important in terms of IOPS.
This whole parallelism gave them 50 times more IOPS compared to UBS1.

So they can do a million IOPS per virtual disk.
Depends on the size, obviously, but the larger the size, the more IOPS you can get.
Maximum throughput per disk is also not bound by a single server now and you can have 4000 megabits per second.
Again, huge improvement, but the network complication costs are pretty high.
Space amplification is way better.
That's 1.29 instead of 3.

But network complication, it's not only your pain for more network, your throughput is basically limited by the network
because every time you write something, you write way more to the network, which is one of the things they want to
address in version 3.

{% include timecode.html time="13:34" %}
So the main goal is basically reducing that number to something more manageable for version 3.
That's like how to reduce the network complications there.

So what they did basically to address that is they added compression and erasure coding on the write path.
For that, because you cannot just do that on the write path because you don't have enough, it will cost you latency in
terms of CPU consumption.
So this is why they address it by leveraging FPGA and offloading that compression to FPGA instead of CPU because that's
just faster to have more specialized hardware.

The other thing is because per disk, you don't have enough throughput per disk to justify 16 kilobytes writes and you
cannot, even 4 kilobyte writes, and you cannot make them smaller or pad them because it will basically make your space
and network efficiency even worse if you pad the data.

So they came up with the approach, what they call a fusion write engine.
I'll talk about those in more detail in a minute.

So basically moving erasure coding and compression to the front end path, to write path of the system.
And for that, they need that fusion write engine and need FPGA.
And the overall result is that they reduced network amplification to roughly 1.6.
And space amplification, again, is pretty small.
Huge improvement of throughput, almost double compared to version two per network card.

{% include timecode.html time="14:52" %}
So how does this fusion write engine work?
So this is a new write path improved for version three.
So basically a write request comes in and goes into this fusion write engine.
The trick of the fusion write engine and the main idea is that at this point, you only care about persistence, but you
don't care about data layout to be super optimized.

So basically, the fusion part of the fusion write engine is that they fuse together writes from different segments,
which means different virtual disks.
They fuse them into the same kind of request or like the same persistent request to Pango.
So they use this hardware acceleration again to compress and do erasure coding.
And then they write it to a journal file, but now the journal file contains data from different segments and different
virtual disks versus previous versions.

Every journal file was corresponding to a particular segment because different segments, like you basically per segment,
you do not have enough throughput to allow for that to do because the overhead per whatever two kilobyte write per
segment is not enough to justify this whole thing.
But if you fuse them together from various segments, you can write for persistence.

{% include timecode.html time="16:36" %}
Yes, you have a little more complicated recovery story, but in terms of performance, it's a huge win.
On the side here, the data files that they still have, per segment, they still maintain them in memory and periodically
dump those data files back to Pango.
Also compressed, I assume with the same hardware acceleration and using slightly different erasure coding algorithms.
So those who are like simplifying recovery, like kind of not relying on that log so much.

But again, the main idea is you, you only care, on the write path, you care about persistence.
You don't necessarily care about putting the data in the right position as long as you can find it later and they can
definitely find it later.

{% include timecode.html time="17:26" %}
So overall evaluation for that performance improvement and network improvement is EBS3 is definitely more performant
than EBS1, more performant than EBS2.

They have graphs and benchmarks on that, but like overall, it just way better performance-wise and that's about it.
But the benchmark they use is YCSB, RocksDB and SysBench MySQL.
So they basically run MySQL on top of their desk and see how well it performs.
So like application level.

#### EBS3: Elasticity

{% include timecode.html time="17:59" %}
The next challenge they talk about is elasticity.
So basically how to make sure that service is providing like those cloud capabilities in terms of elasticity.
And elasticity they discuss in terms of four separate metrics.
Two metrics for latency, which is average and very high percentile, five, nine, stale latency.
And so these are important.

You want your desk to be fast and latency because running MySQL on top of the local disk and running MySQL on the cloud
desk should probably work about okay.
At least that's the goal.

The other two metrics combined kind of like this throughput and IOPS.
And the last one is elasticity of capacity.

I'm going to be talking about latency and throughput and IOPS but not capacity because they barely dedicate any space
for capacity discussion in the paper.

{% include timecode.html time="19:01" %}
So latency.
These are their graphs for basically for latency averages on the left and high-labor latency on the write and where this
latency comes from.
So there are different parts of the system and how they contribute to latency in those scenarios.
One is block cache, first hop of the network, the block server itself, the second hop of the network, Pangoo storage,
the disk I/O in the Pangoo itself, things like that.

So firstly, let's talk about averages.
This is how they discuss it in the paper.
And the thing they notice is like if you look at those colors, on average for EBS3, the network, the second hop of the
network and the actual disk I/O on Pangoo takes a pretty big part of the latency.

So you can get rid of the first hop because it's basically hopped from a virtual machine to your service.
But you can get rid of a second hop and this is what they're trying to do here.
So for the average latency case, they developed EBSX, which is, yeah, as I said, they noticed that the latency was
mostly in the hardware.
So average latency, the cause of that is hardware being there, a network hop being there.

{% include timecode.html time="20:02" %}
So they developed EBSX, which basically stores data locally without the second hop to Pango in persistent memory, which
completely removes the second hop and reduces latency to like an actual I/O device.
And they still store three replicas of that because they need full tolerance and persistence and flush the data
eventually for Pangoo for costs, reasons, and yeah, because the P memory is way more expensive than SSDs.

So that basically gives them this graph for EBSX.
So if you see latency compared to top is write, bottom is read path significantly better for that, but obviously costs
are also higher because you need additional hardware and you still leverage Pangoo on the background.
So you still store basically the same amount, but on top of that, you kind of “cache” writes in persistent memory.

So this is an average case for basically more latency sensitive, more expensive, they called EBSX.
Again, we completely eliminate the second hop and like Pangoo is not there, like the disk I/O is barely visible,
persistent memory on those scales.

{% include timecode.html time="21:43" %}
The other latency case is very high percentile, five, nine percentile on the tail.
And then you notice that basically there's a huge part of the block server being slow quote unquote for those.
So like it contributes a lot to that high percentile latency is specifically software in the block server.
So their investigation found out that contention with background tasks is the reason for that high percentile.

So basically you have an IO thread with doing things and also doing some, doing things for the front end for the write
path of the read path, but also from time to time does interferes or contents with the background task like scrubbing
and compaction or garbage collection in there.
So they moved those to a separate thread.

They also added speculative retry, which is the typical “tail at scale”.
So if the request doesn't come soon enough at some threshold, they just issue another request to another replica or
another block server in this case, and that improves latency.

So the optimized writes and reads for those latencies, again, it's a very high percentile basically, again, completely
eliminated that contention from a block server.
And that huge block of block server latency is no longer there.
It just network hops and disk IO.

{% include timecode.html time="23:15" %}
The other part of the discussion about latency they mentioned is latency is what they call coarse granularity.
Means you cannot fix latency for a particular virtual disk.
You can only fix it in a system overall because like the whole, like there is no latency path for like one disk, but not
the other.

You cannot, for example, throughput and IO where you can scale those things by throwing more hardware at a particular
disk or spreading it out or scaling it up or allocating resources for a particular disk.
Latency in that sense is coarsely granulated.

{% include timecode.html time="23:52" %}
So the next challenge in elasticity is throughput and IOPS per disk.
So you basically want your disk to be able to scale to a lot of throughput because size is kind of not a problem.
You can have as almost as big as you want or a system allows.
And for that they moved things, they moved all their IO processing to user space.

So they started, if you remember from version one, just a regular TCP/AP stack and they moved to their more specialized
networking called Luna and Solar.
Solar is the latest generation as far as I understand.

They uploaded a bunch of IO operations, a bunch of things on the IO path to FPGAs, like CRC calculations and like packet
transmission and just basically added a pretty huge network to that and having that network shifts bottleneck to
internal PCIe bandwidth.

So that is part of the block client.
This is basically the first thing on your write path, which is still in a virtual machine which works, which sends
requests to your clients.
So that is the first bottleneck because you cannot do faster than your block client.

So basically you have to remove all the bottlenecks from there because behind that block client which is a brand on one
machine, you have a huge service where you can increase parallelism and scale up resources, but the block client starts
on one machine.

So you have to make it super fast on one machine handling all those write requests or read requests.
So this is why an FPGA helps for example.

{% include timecode.html time="25:27" %}
On the block server side where like the actual server, they reduced data sector size to 128 kilobytes and they mentioned
reasons like the reducing further kind of incurs more overhead, but 128 kilobytes basically allows them to have a
thousand IOPS input/output operations per gigabyte because the internal parallelism, the way they structure logically
the disk, virtual disks and that's, I guess, considered good enough.

The other thing that they noticed is that a lot of clients actually over provision their disks, virtual disks, because
they wanna make sure that they will not be throttled when they burst.
So they have regular writing activities and sometimes they burst a lot.

So this is why they employ this base plus burst strategy where you have the base capacity where you can actually reserve
for your disk and you have additional burst capacity which is available there as long as you like not to abuse it too
much.

So this is why they have priority based congestion control.
So basically base gets priority as long as you reserve that base IOPS, but you can still have burst capacity.

They do server wide dynamic resource allocation.
So basically within the block server, if there is one of the virtual disks or segments, it's responsible for more in
demand, they would reallocate resources dynamically and add cluster wide hotspot mitigation.
So if certain block servers are getting too hot, segments are getting moved from them and they have logic to do that.

{% include timecode.html time="27:10" %}
And all of those things improve IOPS.
So in the end, the service allows max base capacity at 50,000 IOPS and burst capacity up to a million.

So you can have, and they mentioned that the larger disk you can have is 64 terabytes.
So you can have 64 terabytes with 50,000 IOPS on that disk and basically kind of guaranteed, I guess, quote unquote, I'm
not sure what the actual SLOs are for that and the burst up to a million IOPS.

#### Availability

{% include timecode.html time="27:44" %}
The other important challenge for cloud services is availability.
So we talked about performance and now we're going to talk about availability of the cloud services.

They discuss availability first in terms of blast radius and reducing that and they classify potential events into three
different categories.

The biggest one being global.
So if, for example, a block manager misbehaves, it impacts a big part of the cluster because you kind of don't know
where your blocks for your segments and virtual disks are.

A regional event is something impacting several virtual disks.
For example, block server crashes because blocks are responsible for more for several virtual disks now and single crash
kind of impacts several disks.

An individual is a single virtual disk where they are in detail, I'll talk about that later.

They basically discuss what we usually call poison pill events.
So basically if you have a chunk or a part, basically part of a virtual disk where processing that on a block server
crashes the server.
And technically it is individual.

It might impact only a single virtual disk, but because you have this whole chunk migration between block servers, your
chunk can migrate to the next server and crash that and the next and the next and you basically have this poison pill
and every server in your cluster takes that poison pill and dies and restarts.
And that can impact availability significantly.

And they talk about how they prevent those from actually poisoning the entire cluster.
So the big challenge they start from the global blast radius perspective is the control plane because this is where you
can have a lot of downtime if your control plane is not working properly.

#### Availability: Control Plane

{% include timecode.html time="29:32" %}
And the way they address those challenges is a federated block manager.
So instead of having a single block manager fault tolerant, they have a central manager managing all the other block
managers.

I think the way I understand it, it's like now block managers are no longer fault tolerant.
And if they crash their segments and disks get reassigned to other block managers by central manager, but I'm not
completely certain they explicitly mention that in the paper.

So as I said, a federated block manager is a central manager, now manages all the other block managers.
And the block manager manages what they call partitions now.

So it's kind of a virtual disk level.
So it has a lot of segments in their partitions.
And once a block manager fails itself, these partitions get redistributed to other block managers and presumably a new
block manager starts.
So the crashed one restarts and things like that.

But that logic is now handled by a central manager instead of a guess block manager being fault tolerant themselves.
I think the number they mentioned is on the order of hundreds of milliseconds to redistribute partitions after a block
manager crashes.
So it's pretty great.

Explicitly in the paper, they call out a comparison to AWS paper called millions of tiny databases talking about AWS
Faisalio, which is Amazon's approach to having a high available control plane for elastic block store service.
So that's a comparison if you're familiar with that paper.

#### Availability: Data Plane

{% include timecode.html time="31:16" %}
On the data plane availability, as I mentioned, they mostly talk about individual events, a kind of poison pill and
software.

So basically you have a bug where certain write requests or certain disks, certain chunks call cause your block server
to crash and they want to prevent that crash from propagating across the entire cluster.
They don't call it a poison pill, but I think in general, in the paper, but in general, the term is pretty popular.
So the core idea they have here is they need to somehow isolate those crashing chunks to a small number of blocks.

And for that, they employ a token bucket algorithm.
So basically every segment has three tokens to migrate and tokens replenish at one per 30 minutes and you cannot go more
than three.

And every time you migrate a segment from one block server to the other block server, you spend a token.
And once you're out of tokens, you get migrated to this small subset of, they mentioned three nodes.
So basically you have three block servers which are called logical failure domains.

And if your chunk caused some block servers to basically crash more than three times in like 30 minutes, you will get
that chunk migrated to that logical failure domain and will be there, I guess until it heals or something else happens.
And if there are more chunks like that, they all be moved into that logical failure domain and there are those failure
domains that also merge.

{% include timecode.html time="33:00" %}
So like you will always have just one logical failure domain.
So effectively what you have in the end is all your chunks which cause block servers to crash too often, which is like
three times in 30 minutes or so, they all be moved to the same block servers.

So they will not migrate to other parts of the cluster at all.
So they might cause a lot of an availability in that small subset of block servers, but they will not get out of the
jail.
There's no get out of jail card.
They will be there until something improves.

And they mentioned that that logical failure domain feature actually prevented them from a big outage, which looks like
a very interesting feature and neat feature to me.
Like I've never seen that mentioned anywhere else, that kind of usage of token bucket and basically putting those chunks
parts into like a logical failure domain.

#### Conclusions

{% include timecode.html time="34:02" %}
So conclusions.
Paper talks about the evolution of architecture of block store or elastic block storage from version one to version
three, and also mentioned the latency sensitive version EBSX.

They talk about a lot of lessons and trade-offs they learned and trade-offs they took in those designs, how to approach,
how to address the issues arising from like the previous trade-offs from version one to version two, from version three.

They talk about challenges in availability, elasticity, and how to leverage specialized hardware to offload parts of
workload to improve performance and efficiency.

And with that, I conclude my talk.
Thank you.

