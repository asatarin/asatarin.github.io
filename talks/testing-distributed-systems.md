---
title: Testing Distributed Systems
description: Presented in Moscow in December 2016 at Heisenbug conference and in Yekaterinburg in April 2017. Video and slides are in Russian.
date: 2016-12-10
image: /assets/thumbnails/2016-testing-distributed-systems.jpg
layout: talk
---

Presented in Moscow in December 2016
at [Heisenbug](http://2016.heisenbug-moscow.ru/en/talks/testirovanie-raspredelennyh-sistem/) conference and in
Yekaterinburg in April 2017. Video and slides are in Russian.

### Abstract

Distributed systems meet us on a professional way more often and often.
Modern popular sites and applications contain “under the hood”
a distributed system — they challenge developers due to the fundamental
complexity of their development, and a huge range of possible compromises in design.
Andrey will talk about that part of challenges which are present in testing,
about existing limitations and their impact on functionality.
Issues will be covered:

1. How distributed systems are different from centralized systems?
1. What does it all mean for testing?
1. What properties and characteristics must be checked in distributed systems and how to do it?
1. Which approaches to testing of distributed systems are there and what problems do they solve?
1. What problems do remain unresolved?

The talk is built on an example of persistent distributed queue, which is being developed at Yandex.
Attendees will learn how and what was tested by Andrey along Yandex team and what results were obtained.

[Download slides in Russian (PDF)](/assets/talks/talk-testing-distributed-systems.pdf)

<div class="video-container">
<script defer class="speakerdeck-embed" data-slide="2" data-id="8fbb5337e106474e9753c5359a663239" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div class="video-container">
<iframe src="https://www.youtube.com/embed/h8RV4JfSovg" loading="lazy" frameborder="0" allowfullscreen></iframe>
</div>

### References

- [Testing Distributed Systems](https://asatarin.github.io/testing-distributed-systems/) — curated list of resources on
  testing distributed systems
- ["Simple Testing Can Prevent Most Critical Failures"](https://www.usenix.org/conference/osdi14/technical-sessions/presentation/yuan) —
  great paper with overview of different defect types in distributed systems and how to find them. If you have time to
  read only one paper this is the one.
- [Inside Yandex: Data Storage and Processing Infrastructure](https://events.yandex.ru/events/meetings/15-oct-2016/) —
  several talks on data infrastructure at Yandex (in Russian)
- [Talks by Kyle Kingsbury (Aphyr)](http://jepsen.io/talks) — if you are testing distributed systems you must be
  familiar with Kyle's work

Not exactly references, but you could checkout interviews with me on testing distributed
systems, [one in November 2016](https://habrahabr.ru/company/jugru/blog/313908/)
and [another one in June 2017](https://habrahabr.ru/company/jugru/blog/329974/) (both in Russian).

### Other versions

Shorter version of this talk was presented at DUMP 2017 conference in Yekaterinburg in April 2017.

- [Slides](https://speakerdeck.com/asatarin/tiestirovaniie-raspriedieliennykh-sistiem-dump-2017) in Russian
- [Video](https://youtu.be/QXtr30paTl8) in Russian
 
