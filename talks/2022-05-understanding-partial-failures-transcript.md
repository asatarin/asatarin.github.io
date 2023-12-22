{% comment %}
Draft transcript https://docs.google.com/document/d/1BE5hWA1gmZMKmd8ciQnO2zqMux7ye20Ek_fg1M2GII8/edit#
{% endcomment %}

#### Introduction

{% include timecode.html time="0:09" %}
Hello everyone.
My name is Andrey Satarin. I'm going to be talking about this paper, "Understanding, Detecting, and Localizing Partial
Failures in Large System Software."

{% include timecode.html time="0:23" %}
Rough outline following the paper: we're gonna be talking about what even is partial failure, how we can catch partial
failure, watchdogs, how the proposed method of generating those watchdogs in the paper is with the tool called OmegaGen,
evaluation of this approach, and overall conclusions for the paper.

#### Understanding Partial Failures

{% include timecode.html time="0:45" %}
So, what even are partial failures?

{% include timecode.html time="0:48" %}
In the paper, they describe partial failures as a failure in the process when a fault does not crash the process but
causes the safety or liveness violation or severe slowness for some functionality. So it's at the process level, not the
usual stuff we use in distributed systems at the node level, where some nodes crash and some don't. The process is still
alive, so it's not the typical fail-stop failure. Again, as the usual ones, the health checks people implement for those
distribution systems could miss those failures specifically because the process is still alive, but they can still cause
catastrophic outages in the real world.

{% include timecode.html time="1:29" %}
Failure Hierarchy:

{% include timecode.html time="1:32" %}
The simplest one is a fail-stop — your process stops and never restarts again. Something more elaborate is
fail-recover, where the process stops, recovers, and continues with some lost state. A mission failure is where not only
that can happen, but you can also lose some packages or request responses. And the biggest of all, the Byzantine
failure, is when the process can do whatever it can, even actively have malicious behavior, trying to basically destroy
your system from within.

{% include timecode.html time="2:10" %}
So, the way I understood it, they don't mention it in the system itself, the partial failure falls somewhere between
Byzantine and omission failure, because some of them could be seen as a mission of certain packages. For example, your
compaction fails, so you cannot do writes, and that means obviously all the write packages for write operations are
lost. But the system itself can still process reads, but some of those failures are even more complex, so they can
exhibit somewhat Byzantine failures.

{% include timecode.html time="2:44" %}
This is why I kind of put them in here, but they don't specifically mention it in the paper. This is my understanding of
the area we are talking about.

{% include timecode.html time="2:53" %}
Researchers in the study basically asked two questions overall: how do partial failures manifest in modern systems, and
how to systematically detect and localize those failures at runtime?

{% include timecode.html time="3:09" %}
So, let's dive deep into what they're actually describing. They researched five different distributed systems,
well-known, established, mature distributed systems over a wide range of dates, and they found 20 cases for each, 20
partial failure cases for each of those systems, overall 100 partial failures, and they kind of study what's in this, on
those sales, how they exhibit in the system.

{% include timecode.html time="3:36" %}
Findings 1-2:

{% include timecode.html time="3:38" %}
First of all, all of those systems do have partial failures. They exhibit the majority of them, roughly 50%, in most
recent years. So even mature systems do have those; they're not getting ironed out in testing or anywhere else. Root
causes are very diverse, so there's no single root cause or majority root cause. The three top ones are uncaught errors,
indefinite blocking, and buggy error handling – usual suspects, to a degree.

{% include timecode.html time="4:20" %}
[Pat Helland](https://twitter.com/pathelland):
But finding two is about flaws in the system.
Finding one is that these things are happening. Is there anybody doing an analysis of the trend line? Because it feels
to me like that, as data centers get more congested and crowded, it's like freeways getting crowded, and it'll open up
and accentuate these failures we're talking about.

{% include timecode.html time="4:35" %}
I'm not aware of any research in this particular area, like what the trends are, is it getting worse or better? I assume
because the system gets more complex, the more stuff you have in a single node, the more chances there are for partial
failures, but also in networks and network timings and EC2 outages, and you see partial outages.

{% include timecode.html time="5:06" %}
In the paper, they talk about the partial failures as localized to a single node. Networks could be completely healthy
in that sense.

{% include timecode.html time="5:34" %}
The definition of a partial failure is a failure where it doesn't crash, but some functionality is lost.

{% include timecode.html time="6:35" %}
Findings 6-7:

{% include timecode.html time="6:38" %}
Finding three is that roughly 50% of them are liveness violations, so those are somewhat easy to detect and
straightforward. You just see things being slow, which means liveness is violated, and that means there's a partial
failure. But the minority of them are things like 13% or "zombie" with undefined failure semantics, which I also kind of
put in the Byzantine failure category. This is why there's an overlap before, and some of them are silent, so you have
data loss, corruption – those you cannot detect easily with any simple check. You need to actually understand your
system's guarantees and deeper semantics.

{% include timecode.html time="7:24" %}
Finding six is that 70% of those failures are specific to environments, so there's something happening at runtime. So we
cannot iron them out with any amount of testing, basically, unless we try to do some kind of live testing. What authors
advocate is that we need runtime checking because we will not be able to iron out all the various runtime scenarios at
the testing stage.

{% include timecode.html time="7:47" %}
The majority of these failures are sticky, so the process will not recover by itself, but it needs some kind of recovery
mechanism or maybe even a simple restart. Other than that, they don't talk about recovery in the paper a lot. They even
mention this as one of the limitations and something they want to work on, like how to recover from partial failures. At
this point, they're only interested in detecting and localizing those.

{% include timecode.html time="8:12" %}
So how do we catch partial failures? The proposed approach is watchdogs, something running at runtime to catch these
failures.

#### Catching Partial Failures with Watchdogs

{% include timecode.html time="8:23" %}
[Murat Demirbas](https://twitter.com/muratdemirbas):
Andrey, Rohan asked a good question in the chat. Are temporary errors considered as partial failures? The finding seems
to suggest that maybe the temporal errors are also partial failures, but 68% of the partial failures are sticky rather
than temporary. Is that right or do we make a distinction?

{% include timecode.html time="8:30" %}
Regarding temporary errors and whether they are considered as partial failures, finding seven suggests that maybe the
temporary errors are also partial failures, but 68% of the partial failures are sticky rather than temporary.

{% include timecode.html time="8:52" %}
They mention later in the paper, in the detection phase, where some of them could be very temporary, and we don't want
to produce a false alarm on that, where something is just slow for a second, for example, due to congested disk or other
reasons.

{% include timecode.html time="9:06" %}
The other scenario is the disk is slow, but it's slow for a prolonged period of time for some other reason, like being
congested, or you are out of disk space and that blocks your writes, for example. So, I'm not sure if there is any kind
of timeline. Right, I don't think there is a definite threshold.

{% include timecode.html time="9:30" %}
[Murat Demirbas](https://twitter.com/muratdemirbas):
Okay, good. Thanks

{% include timecode.html time="9:36" %}
It's kind of the same with availability and latency – was the system unavailable, or was it just a really long latency?
What's the difference? It's the same with partial failures – was it a partial failure or just a slow disk write?

{% include timecode.html time="9:56" %}
The current situation, as described by the authors, is that systems use checkers, which can be divided into two
categories: probe checkers, where you execute something through an external API (like a key-value system), and signal
checkers, where you monitor some health indicators like CPU usage or disk bytes written.

{% include timecode.html time="10:31" %}
Issues with Current Checkers:

{% include timecode.html time="10:33" %}
For probe checkers, the API surface of modern systems is pretty big, so it's hard to cover them with any manual probes.
Partial failures might not even be observable at the API level, which raises some questions. If it's not observable at
the API level and the customer doesn't exactly care what happens in the system, then why are they saying that? Signal
checkers are susceptible to noise and have poor accuracy, which will be cited later in the evaluation section.

{% include timecode.html time="11:14" %}
The approach they propose is to have what they call mimic-style checkers, which are basically selected representatives
of some operations performed by the main program. By imitating these operations, we can detect errors and, because we
imitate them at a lower level, we can pinpoint failures with more accuracy to a specific module or even an instruction
in the code.

{% include timecode.html time="11:45" %}
These checkers are put in what they call "intrinsic watchdogs," which seem to be more deeply integrated into the main
program than the usual watchdogs. Intrinsic watchdogs have a synchronized state from the main program, so the state of
the main program gets copied into the watchdog. The watchdog executes concurrently but still lives in the same address
space as the main program, so they could suffer the same consequences as low memory or garbage collection policies. They
specifically want them to be there to suffer those consequences.

{% include timecode.html time="12:26" %}
They advocate generating these watchdogs automatically based on the code of the program. The example they provide shows
a main program with different modules, such as a request listener and snapshot manager, and a watchdog with mimic
checkers, where each checker mimics the behavior of a certain module or thread. The context is basically information
copied from the main program to those checkers.

#### Generating Watchdogs with Omegagen

{% include timecode.html time="13:26" %}
Omegagen is the tool they're talking about, which generates these watchdogs.

Generating Watchdogs:

{% include timecode.html time="13:36" %}
To generate a watchdog with Omegagen, there are certain steps you need to take. First, they identify long-running
methods, like while loops, because this is where the main method of the program resides. Second, they locate vulnerable
operations, such as writing to disk or a socket, but not something like computation in memory, like sorting. Third, they
reduce the main program by throwing out everything except those vulnerable operations. Then, they encapsulate the
reduced program with context factory and hooks, which means copying all the local state from the main program to the
checker and executing those vulnerable operations in the checker. Finally, they add checks to catch faults.

{% include timecode.html time="15:00" %}
For example, in the code, they first identify a long-running region where they're taking some snapshots. Then, they find
vulnerable operations, like writing some records. Next, they reduce the code by removing everything except the local
state needed to call that vulnerable operation. After that, they insert hooks to copy that local state into the context
manager to later get that context and local state in the watchdog. Lastly, they generate checkers and add faults and
signals.

{% include timecode.html time="16:04" %}
Basically, on the right side, we have the checker, which does a simple write with the same arguments copied from the
main program. This is how Omegagen works, and I'll talk about how it doesn't ruin the program in the process of
generating those watchdogs.

{% include timecode.html time="16:25" %}
So, after we've caught the faults, we need to validate the impact. Is this actually just a single slow disk operation,
or is it some kind of trend? They have a validation step after each alert internally in the Omegagen generated set. The
default validation is basically to rerun the check, trying to write or read again to see if it's still slow or just some
intermittent issue.

{% include timecode.html time="16:57" %}
There are tools to allow developers to manually extend those validations. One of the parts Omegagen has to do is prevent
side effects, because we're trying to mimic exactly the same operation with the same parameters. They redirect writes so
that instead of writing to the same file on the local file system, they write to a different test file. They still write
the same data, so if they write a megabyte in the main program, they will write a megabyte of data in the watchdog, just
in a different file.

{% include timecode.html time="17:55" %}
It is definitely a sample, and the purpose is to get a sense of what the performance ought to be in the primary system.
They have a hard threshold of four seconds for timeout as their liveness threshold, but they also look at the drift of
average time. If it drifts slowly, they will detect that too, if there is just degradation of disk or network at a
slower pace.

{% include timecode.html time="18:32" %}
But it's not hitting the threshold for individual operation yet, so all your writes suddenly, instead of three
milliseconds, are one second. It will also impact your program, but you will not detect it with a static threshold.

{% include timecode.html time="18:45" %}
[Pat Helland](https://twitter.com/pathelland):
And this is all driven to decide when to kill the primary?

{% include timecode.html time="18:49" %}
It's actually to detect partial failures, not necessarily to kill
the program. They report it to the operator, as they don't talk about recovery in this context.

{% include timecode.html time="19:16" %}
With reads, they do item potential wrappers, so the main program reads the stuff in the buffer, and the checker reads it
from the buffer to simulate the read while also looking at the timings.

{% include timecode.html time="19:34" %}
For socket operations, they just turn them into pings to avoid side effects. Another approach they suggest, although not
in great detail, is to apply Omegagen to an external storage system if you write to it. In theory, your fault detection
can talk to the Omegagen watchers on the other side and decide if it failed for your use case or if it completely
failed.

{% include timecode.html time="20:15" %}
But they just mention that as one of the approaches for the future, I guess.

#### Evaluation

{% include timecode.html time="20:22" %}
For the evaluation stage, they ask several questions: Does this work for large software? Can we actually detect and
localize real-world partial failures? Do the watchdogs provide strong insulation and not interfere with the original
program? What about the false alarms; can we lower the false alarm rate? What's the runtime overhead in terms of
performance and memory?

{% include timecode.html time="21:02" %}
For detection, they collected and reproduced 22 failures across different systems. Their watchdogs managed to detect 20
out of those 22 partial failures. They ran the systems, injected the faults as described in the original bug reports,
and the generated watchdogs detected the issues 20 times out of 22 with a median detection time of five seconds, which
is an amazing detection time.

{% include timecode.html time="21:34" %}
Overall, they were highly effective against liveness issues, as you don't need to know the exact semantics of your
program to know it's slow. They were also effective against safety issues, which are explicitly marked in the program
with exceptions or errors. However, they may not be effective against silent issues, as you need to understand the deep
semantics of the program to know the data is corrupted.

{% include timecode.html time="22:29" %}
It took them a week on average to reproduce each failure. They ran the system with 22 real-world failures, where a
single slow node could slow down the entire system due to partial failure. They injected the fault as described in the
bug report, possibly with some trial and error or timing guesses.

{% include timecode.html time="23:28" %}
So, for detection, 20 out of 22 failures were detected, which is pretty good.

{% include timecode.html time="23:49" %}
For localization, they mentioned that out of those 20 detected failures, they managed to directly point to the
problematic instructions in 11 cases. If you have a slow write, the watchdog will tell you that this particular code
section is slow, and it will correspond to the main program because the watchdog was generated from that specific point
in the main program.

{% include timecode.html time="24:13" %}
For seven of those cases, the problematic code was either within the same function or along the call chain. This is much
better than just saying the system is slow or the writes are slow, which could happen for many different reasons.

{% include timecode.html time="24:54" %}
They also looked at false alarms and calculated the false alarm ratio as the total number of false failure reports
divided by the number of total check executions. If they run checks every second, that would mean about 86,000 checks
per day.

{% include timecode.html time="25:25" %}
The median detection time is five seconds, which is incredibly fast. However, there might be a trade-off between false
alarm ratio and detection time. For example, what if the detection time was a minute, but the false alarm ratio was an
order of magnitude better?

{% include timecode.html time="24:35" %}
The actual false alarm ratios are like that, so this is the table from the paper. The first row is watchdogs, the second
row, watchdogs_v, is watchdogs validators.

{% include timecode.html time="25:47" %}
So, validators, as I said previously, basically, the default validator is just to rerun the same operation. So, if it
was a slow rate, we rerun the rate and see if it's still slow.

{% include timecode.html time="25:59" %}
Or, I think they mentioned sometimes they do more, kind of manually written validators for some systems, but they don't
provide a lot of details on that.

{% include timecode.html time="26:15" %}
The lowest false alarm ratio was 0.01%, which means one in every 10,000 checks would be a false alarm. This equates to
roughly eight false alarms per day, which could be considered a high number in real-world scenarios. This issue could be
addressed by running checks less frequently or by further reducing the false alarm ratio.

{% include timecode.html time="26:45" %}
[Pat Helland](https://twitter.com/pathelland):
And that's the real problem with fail-fast, with detecting and killing and replacing in a timely fashion because as the
behavior of the systems gets less prompt with everything, it's not a synchronous network, it's not pulsing, you know,
this many times a second.
Then, knowing when it's just sick versus when it's really dead gets harder and harder, and hence there's pressure to not
make a rapid decision because of the inaccuracy of a rapid decision.
Yeah, but you're right, I mean, the false alarm ratio should be related to the rapidity of the check.

{% include timecode.html time="27:12" %}
The false alarm ratio should be related to the frequency of the checks and the comprehensiveness of the validators. They
don't mention if the retry recheck is done right away or if there is a grace period to allow the system to recover.

#### Conclusions

{% include timecode.html time="27:48" %}
In conclusion, the researchers studied 100 real-world partial failures in popular software like Zookeeper and Hadoop.
They created the tool OmegaGen to generate watchdogs from the code. The generated watchdogs detected 20 out of 22
partial failures they tried to reproduce and pinpointed the scope for almost all of them (18 out of 20) with more
precision than just identifying a slow process. The paper also revealed a new partial failure in Zookeeper, which was
confirmed and fixed by the Zookeeper team.

{% include timecode.html time="28:25" %}
And they also talk in the paper; they actually exposed a new partial failure in Zookeeper. So it's not just the old
stuff they were able to reproduce; they found a new bug. My understanding is it was confirmed by the Zookeeper team
and was also fixed. So, not only were old failures reproduced, but new ones were also discovered and reported as
actual partial failures during their experiments. With that. Yeah, I'm done. Thank you.

{% include transcript-code.html %}
