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

{% include speakerdeck.html data_id="5d8f859e5d5d4865b867d5e4b1b69f68" %}

{% include youtube.html video_id="2ybZcLXbJp8" %}

### References

- "Understanding and Detecting Software Upgrade Failures in Distributed
  Systems" [paper](https://dl.acm.org/doi/10.1145/3477132.3483577)
- [Video](https://youtu.be/29-isLcDtL0) from SOSP 2021
- [Reference repository](https://github.com/zlab-purdue/ds-upgrade) for the paper
- [DUPTester tool code](https://gitlab.dsrg.utoronto.ca/zhuqi/DUPTester)
- [DUPChecker tool code](https://github.com/jwjwyoung/DUPChecker)
- [Jepsen.io](https://jepsen.io/)
- "Simple Testing Can Prevent Most Critical
  Failures" [paper](https://www.usenix.org/conference/osdi14/technical-sessions/presentation/yuan)
- Curated list of resources on [testing distributed systems](/testing-distributed-systems/)

### Transcript

{% include transcript.html filename="2022-09-upgrade-failures-in-distributed-systems.transcript.md" %}
