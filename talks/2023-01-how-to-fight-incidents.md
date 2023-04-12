---
title: How to Fight Production Incidents?
description: >
  Talk on "How to fight production incidents?: an empirical study on a large-scale cloud service" paper for distributed systems reading group.
date: 2023-01-25
image: /assets/thumbnails/2023-01-how-to-fight-incidents.webp
layout: talk
---

This is a talk on "How to fight production incidents?: an empirical study on a large-scale cloud service"
paper for distributed systems [reading group](http://charap.co/category/reading-group/).

### Paper

"How to fight production incidents?: an empirical study on a large-scale cloud service"
by Supriyo Ghosh, Manish Shetty, Chetan Bansal, Suman Nath.

Paper published in [SoCC 2022 proceedings](https://dl.acm.org/doi/proceedings/10.1145/3542929).

#### Paper Abstract

Production incidents in today's large-scale cloud services can be extremely expensive in terms of customer
impacts and engineering resources required to mitigate them. Despite continuous reliability efforts,
cloud services still experience severe incidents due to various root-causes. Worse, many of these
incidents last for a long period as existing techniques and practices fail to quickly detect and
mitigate them. To better understand the problems, we carefully study hundreds of recent high severity
incidents and their postmortems in Microsoft-Teams, a large-scale distributed cloud based service used
by hundreds of millions of users. We answer: (a) why the incidents occurred and how they were resolved,
(b) what the gaps were in current processes which caused delayed response, and (c) what automation could
help make the services resilient. Finally, we uncover interesting insights by a novel multi-dimensional
analysis that correlates different troubleshooting stages (detection, root-causing and mitigation),
and provide guidance on how to tackle complex incidents through automation or testing at different granularity.

[Download slides (PDF)](/assets/talks/2023-01-how-to-fight-production-incidents.pdf)

{% include speakerdeck.html data_id="81e6da6877c5410eb0780b44698f11b0" %}

{% include youtube.html video_id="j6Z-TawfQns" %}

### References

- "How to fight production incidents?: an empirical study on a large-scale cloud
  service" [paper](https://dl.acm.org/doi/10.1145/3542929.3563482)
- [Slides](https://acmsocc.org/2022/assets/slides/95.pdf) for the talk presented at SOCC 2022 by the authors
- [Reading Group. How to fight production incidents?](http://charap.co/reading-group-how-to-fight-production-incidents-an-empirical-study-on-a-large-scale-cloud-service/)
  blog post by [Aleksey Charapko](http://charap.co/about-me/) on the meeting with overview of the discussion
- Overview talk
  on [“Understanding and Detecting Software Upgrade Failures in Distributed Systems”](/talks/2022-09-upgrade-failures-in-distributed-systems/)
  paper
- Overview talk
  on [“Understanding, Detecting and Localizing Partial Failures in Large System Software”](/talks/2022-05-understanding-partial-failures/)
  paper
- "Simple Testing Can Prevent Most Critical
  Failures" [paper](https://www.usenix.org/conference/osdi14/technical-sessions/presentation/yuan)
- Supriyo Ghosh`s [personal website](https://sites.google.com/site/supriyophdsmu/)
  and [Twitter](https://mobile.twitter.com/supriyo_ai)
- Manish Shetty`s [personal website](https://manishshettym.github.io/)
  and [Twitter](https://mobile.twitter.com/slimshetty_)
- Chetan Bansal`s [page](https://www.microsoft.com/en-us/research/people/chetanb/) on Microsoft Research website
- Suman Nath`s [page](https://www.microsoft.com/en-us/research/people/sumann/) on Microsoft Research website

### Transcript

{% comment %}
Draft transcript https://docs.google.com/document/d/1Y5gXyjd5Lt_Plzmw3FKc2RPY_IZoNdcwi5DVex4hfoo/edit
{% endcomment %}

Please note that this AI-generated video transcript may contain inaccuracies or omissions.
I encourage you to use it as a reference only and verify information with the original video if needed.

<hr>

<span class="timecode">0:05</span>
Hi everyone! Today, I’m going to be talking about this paper, “How to Find Production Incidents: Empirical Study”.

<span class="timecode">0:13</span>
Links and slides will be on that link, and all the references and all this stuff, and the video too.

<span class="timecode">0:21</span>
So, a quick outline following the paper: first, we’re going to talk about the methodology the author used to study
those incidents. They looked into root causes and mitigation strategies. They looked into delays, what caused those
delays in terms of detecting, reposing, and actually acting in mitigation. They have some lessons learned, which they
analyzed from the actual on-call engineers who wrote reports.

<span class="timecode">0:50</span>
They classify those in different categories, and in the end, they have a multi-dimensional analysis between all
those categories to see what the main trends and conclusions are, of course.

<span class="timecode">1:01</span>
So, the methodology - where does that data come from, and what do they do with this incident report? All the
incident reports come from a single, at least user-facing service, Microsoft Teams. I’ve seen there are more than one
service behind that, and they analyzed and studied 152 different reports.

<span class="timecode">1:21</span>
They looked at their mitigation, root causes, the direction, and mitigation approaches. They only looked at the
reports which included the complete post-mortem report, and they mentioned that 35 more they didn’t look at because they
didn’t have the full post-mortem report with all the details they needed for analysis.

<span class="timecode">1:43</span>
Even though all of those reports are incidents of high severity, there’s still a breakdown between the different
severities. There’s just one, I assume, large-scale incident, that’s Sub-Zero. Thirty percent of all the incidents, like
40-50, all those were Severity 1, and the rest of them were Severity 2.

<span class="timecode">2:09</span>
Any incident included in the study has to impact either an internal service or have a dimension impact on several
tenants or customers. But I assume “impact” doesn’t mean downtime; it could be maybe increased latency or things like
that, or error rate. But still, an impact doesn’t mean it is visible to all the users or very negatively perceived, but
they’re still limited.

<span class="timecode">2:31</span>
So, what did they look at? They looked at the root causes - what is the actual cause of the incident, and they only
assigned one particular category as the root cause for an incident.

<span class="timecode">2:59</span>
They also looked at mitigation steps, what on-call engineers actually performed to resolve an incident, whether it
was rollback, code fixes, or added capacity, and so on.

<span class="timecode">3:18</span>
They examined how incidents were detected and monitored, whether it came from users or other sources.

<span class="timecode">3:32</span>
They also looked into what delayed incident resolution and which factors contributed to that.

<span class="timecode">3:46</span>
Lastly, they explored any automation opportunities to improve future mitigation, root cause analysis, or other
aspects.

<span class="timecode">3:59</span>
The overall goal is to find what lessons to take away from this and how to improve the resiliency of cloud services
in general.

<span class="timecode">4:11</span>
So, as I mentioned before, it is just a study of one floor service even though it consists of many services like
databases and other things. But there is some versatility, so it is only Microsoft Teams. If you’re running a service
which has nothing similar to Microsoft Teams or like a messaging service, those results might not directly apply.

<span class="timecode">4:45</span>
Also, Microsoft already has some effective tools and techniques for testing and rollout, like deployment tools and
things like that. Basically, they’re very mature in that space, and those already prevent a large amount of incidents.
So, depending on your kind of maturity level in terms of tools and all the role processes of running a cloud, you might
not see the same results or might be a breakdown between the causes and effects, and mitigation strategies could be
completely different from that.

<span class="timecode">5:15</span>
And as I mentioned, they left out 25% of the incidents because the post-mortem report did not have all the details
they needed. So, potentially those might skew results in a significant way, but I think they don’t expect that to be the
case.

<span class="timecode">5:31</span>
So, what about root causes? Basically, the paper presents all the information in breakdowns between different root
causes, like the Codex 27. It kind of reads a little bit as a statistical report of sorts. It may be a little bit harder
to digest, but they also list 15 or 16 findings in a more narrative way.

<span class="timecode">6:04</span>
In terms of what causes the major contributors, they are still code bugs and config bugs. Any kind of configuration
change you make might cause an incident or instability. Some other things include dependency failures, like using a
database that has an incident on its own. They categorize database, network, and support categories, but overall,
dependency failures are similar.

<span class="timecode">6:40</span>
That’s the same with authentication. It is a dependency of sorts, but just a reasonably special kind. 40% of
incidents here are either a code bug or configuration bug, but the rest of them are not, which means there are still
plenty of errors coming from things you’re not changing in your version control.

<span class="timecode">7:20</span>
Regarding mitigation steps, there are a lot of different strategies. The most popular one being rollback. They list
specifically what they mean by interchange and increasing capacity and things like that. External fix, I think, applies
to some of the services you rely on, like dependency and configuration seeks and conflicts. An on-call fix is something
like what an on-call engineer does, some kind of manual process.

<span class="timecode">8:01</span>
So, for example, some tweaking with the system and transient system just restores itself. A monitor, like
monitoring depth, alerts you on an incident and then everything self-healed or something like that. System restored
itself.

<span class="timecode">8:18</span>
So even though 40% of incidents were caused by code or configuration bugs, 80% of those were mitigated without any
code or configuration blocks. I assume because the strategies are kind of faster, they don’t involve a deployment cycle.
That makes, or the same overall back. This is why Canada, I think they mentioned it in one of the other findings, where
rollback is a popular strategy because it’s pretty quick. The rollback and the infrastructure change, because they’re
quick, they do account for about 40% of incidence mitigation. Just because you don’t go through more labor cycles of
contributions fixing forward with the code pixel, conflict figs, and reviewing it, presumably, and rolling it forward or
through your deployment system, which takes time then.

<span class="timecode">9:26</span>
In another aspect, they looked at delays in response. So basically, what are the causes of that? And one of the
main things is that finding number five is that time to detect code bugs and dependency is hard to detect because the
time it takes for people to detect the code bugs is just larger than any other. And I think some of the findings also
mentioned that their bugs specifically are hard to monitor, so it’s hard to come up with monitoring to find all the
various bugs the system has. And it also makes it sound complicated in resolution.

<span class="timecode">10:16</span>
Yeah, and things like configuration ticks and Cloud picks take longer time. Again, it corresponds with one of the
previous findings. It’s just easier to roll back, usually if you can do that. Obviously, not every system can do that if
you change the data underneath, and you can’t roll back with all other scale services. Usually, keep that option open
for basically any change you can just because it is so convenient to have options to roll back. Galaxy has something to
say about that in terms of metastability and things like that, but rollback is still a popular resolution.

<span class="timecode">11:11</span>
Detection value is basically why we lose not detected issue incidents faster? Things like not failing at all. So,
I guess I’m not actually sure what they mean by that not failing category. I guess there is no detection except maybe
the user or option system. Other popular ones are like lack of monitors or Telemetry coverage, which also causes a
delay. Basically, some of the things which indicate that your system isn’t having an incident that’s just not covered by
monitors for whatever reason or in any other telemetry, and that makes it harder to deduct and delays any kind of
resolution. Mitigation failure categories, so like.

<span class="timecode">11:49</span>
And that makes it harder to deduce and delays any kind of resolution. Mitigation failure categories, so what cost
mitigation to get delayed and fail? These are sometimes related to procedures, so not just systems themselves but also
procedures which are kind of like part of the socio technical system but not code or anything like that. Sometimes it is
just delays in deployment and a lot of times it’s unclear 27% of times they just on call Engineers who wrote the report
don’t know what caused the delay mitigation.

<span class="timecode">12:38</span>
This kind of tells us that this whole thing is pretty complicated in terms of figuring out what actually causes
those things because even on-call engineers who had way more contacts in the particular incident still don’t have enough
information to make that call.

<span class="timecode">12:59</span>
As I mentioned, like 30% of those are not caused by any systems itself but by some kind of documentation
procedures. This is one of the funniest and manual deployment stuff so there’s opportunity for automation, opportunity
for improvement even without changing the code or like I guess except the manual deployment investing in tools, but you
can still have improved time to mitigate by changing the communication procedures or improving those.

<span class="timecode">13:34</span>
Overall, Lessons Learned, basically this is not what odd as part of this and this is not what authors like kind of
learn from all incidents, this is what they aggregated across different categories of incidents what actual on-call
Engineers put in the Lessons Learned category for specific incident and then they aggregated them in different
categories to see like what are the and excuse me I need to fix that.

<span class="timecode">14:07</span>
So yeah, Lessons Learned is the main driver is manual tests, and so basically testing is still a big theme and I
think it gets even more important later when they mention other points in other findings. Sometimes it’s just unclear
what the lesson is from the incident. Sometimes they need a test or configuration test or manual test or improve in
alerting triaging things like that automated deployment.

<span class="timecode">14:44</span>
So yes, improving testing was a popular choice so this had like testing is important figuring out before figuring
out that the system is broken before production is important but like unfortunately Papercut doesn’t go into the details
like what kind of testing is helpful there are some other papers who will which are like focused specifically on
incidents caused by bugs and how to address those but that paper is more high level I guess and it doesn’t go into
detail in actually how to improve the testing just as like yes on-call engineers think that in a lot of incidents
testing and detecting issues with the system earlier in a cycle before it gets deployed to production is important but
they don’t talk much or at all about what kind of testing and how to prevent those incidents with specific tasks.

<span class="timecode">15:39</span>
They basically have just two categories of test: regular test and configuration test. Configuration test is also a
liquid pretty vast category and can look completely different depending on what you’re targeting. So yeah, overall
improved testing you improve monitoring things like that.

<span class="timecode">16:04</span>
It’s like the “lost and learn” category.

<span class="timecode">16:07</span>
Investing in automating mitigation, and again, I’m clear, it’s a pretty large category here, 37.

<span class="timecode">16:19</span>
Which means, like, engineers do not only see the clear lesson from an incident on how to avoid it, or mitigate or
resolve it faster in the future.

<span class="timecode">16:37</span>
So yeah, overall, kind of like 20% of feedback indicated that just behavioral change or documentation training
might improve incident management. So this is one of the major categories. Basically, you can improve 20% resolution of
your incidents with some kind of better documentation, better incident training, things like that.

<span class="timecode">17:03</span>
It could be considered, I guess, less investment than in the systems if you want to build resilience.

<span class="timecode">17:15</span>
The last section of the paper is a multi-dimensional analysis about how all those categories align with each
other, and it is kind of complicated. I think it’s not very digestible in terms of presentations.

<span class="timecode">17:35</span>
But you can definitely look it up in the paper. They have all those graphs like, “so what corresponds to what?”
and “what is the most popular choice?”, “how different categories correlate to each other?”.

<span class="timecode">17:49</span>
I’m just going to present their findings without the actual data that they present in the paper.

<span class="timecode">17:56</span>
As I said, for code changes, people say that improving testing is important, which is kind of hard to disagree
with.

<span class="timecode">18:01</span>
Even since, for example, the “Simple Testing Can Prevent Most Critical Failures” paper from 2014, a while ago.

<span class="timecode">18:12</span>
But as I said before, authors in this analysis don’t go into details like what kind of testing is actually
helpful, unlike, for example, the “Simple Testing” paper where they talk in detail and look way deeper into incidents
and some other papers too, where incidents were caused by bugs and how to address those bugs with tests.

<span class="timecode">18:38</span>
Here, it’s just like, yeah, 70% of incidents are of normal dollars, improved testing rather than monitoring. So,
monitors for code blocks are hard to build, and it’s better to detect code issues even before code reaches production.

<span class="timecode">19:01</span>
Monitoring, on the other hand, with related services, should be improved because you cannot test your way out of
an outage in a related service or their misbehavior. But you do, because those inherently happen in the runtime, at
least the ones they found in the study majority.

<span class="timecode">19:28</span>
This is why you kind of need to improve monitoring and observability coverage across related services.

<span class="timecode">19:38</span>
Again, more testing. Everyone likes more testing. So, configuration bugs are mitigated with rollbacks, and these
are usually recent changes. Configuration bugs are either, they don’t, I guess, they don’t lie dormant for a long time,
they either cause incidents, right away, or they just make changes.

<span class="timecode">20:05</span>
So, they do talk about that, that you probably shouldn’t invest in rigorous configuration testing, but again, they
don’t elaborate on what that actually looks like and what the gaps are.

<span class="timecode">20:27</span>
Incidents with manual effort and improvements in training are important. Some automation for reducing manual
effort is needed, because on-call fatigue was recognized as one of the issues here too.

<span class="timecode">20:45</span>
Which is, I guess, kind of aligned with conventional wisdom. You don’t want a lot of manual steps in any kind of
incident management or deployment or things like that, and not at all surprising.

<span class="timecode">20:58</span>
For mitigation delay due to manual deployment steps, which is again not surprising and is kind of very
conventional.

<span class="timecode">21:14</span>
So, mitigation steps include automation like traffic failover, rebooting, and auto-scaling.

<span class="timecode">21:23</span>
Conclusions from the paper: they did look at 152 incident reports, which is a pretty large number of reports over
one year, from May 2021 to May 2022.

<span class="timecode">21:37</span>
They have identified the categories of automation opportunities based on those incident reports. They do have
important multi-dimensional insights from multi-dimensional analysis, and they presumably will help you improve
reliability. Even though those are, in my opinion, kind of high level, they don’t tell you more details on testing, code
testing, integration, and how to actually achieve that.

<span class="timecode">22:11</span>
But it’s still valuable information for improving documentation or listening. I guess it’s going to be pretty hard
to figure out, especially in general terms, what kind of documentation needs to be improved.

<span class="timecode">22:25</span>
Actually, Microsoft Teams had an outage today or last night, whatever it happened. So, this is the tweet from a
few hours ago. They rolled back a network change.

<span class="timecode">22:36</span>
I kind of just saw that before the talk, and it was interesting to see what they were doing. Apparently, they were
doing the same things they talked about in the paper. So, they did roll back the change, which is the most popular
mitigation strategy.

<span class="timecode">22:57</span>
The database network is not the most popular root cause, but it is definitely a separate category there. It was
kind of interesting to analyze based on the very limited information in a tweet about what’s going on.

<span class="timecode">23:18</span>
And they’re saying that they’re monitoring, so monitoring is again mentioned as one of the important things to
resolve issues and incidents and see how the system is doing.

<span class="timecode">23:30</span>
Yeah, that is it. Everything I wanted to say about the paper.

<span class="timecode">23:36</span>
Thank you.

{% include transcript-code.html %}