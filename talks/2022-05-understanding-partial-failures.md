---
title: Understanding Partial Failures in Large Systems
description: Presentation on "Understanding, Detecting and Localizing Partial Failures in Large System Software" paper
for distributed systems reading group.
date: 2022-05-25
image: /assets/thumbnails/2022-05-understanding-partial-failures.jpg
layout: talk
---

This is a talk on "Understanding, Detecting and Localizing Partial Failures in Large System Software"
paper for distributed systems [reading group](http://charap.co/category/reading-group/)
lead by [Aleksey Charapko](https://twitter.com/AlekseyCharapko).

### Paper

"Understanding, Detecting and Localizing Partial Failures in Large System Software"
by Chang Lou, Peng Huang, and Scott Smith. Presented
at [NSDI 2020](https://www.usenix.org/conference/nsdi20/presentation/lou).

#### Paper Abstract

Partial failures occur frequently in cloud systems and can cause serious damage including
inconsistency and data loss. Unfortunately, these failures are not well understood.
Nor can they be effectively detected. In this paper, we first study 100 real-world partial
failures from five mature systems to understand their characteristics. We find that
these failures are caused by a variety of defects that require the unique conditions
of the production environment to be triggered. Manually writing effective detectors
to systematically detect such failures is both time-consuming and error-prone.
We thus propose OmegaGen, a static analysis tool that automatically generates
customized watchdogs for a given program by using a novel program reduction
technique. We have successfully applied OmegaGen to six large distributed systems.
In evaluating 22 real-world partial failure cases in these systems, the generated
watchdogs can detect 20 cases with a median detection time of 4.2 seconds, and
pinpoint the failure scope for 18 cases. The generated watchdogs also expose an
unknown, confirmed partial failure bug in the latest version of ZooKeeper.

[Download slides (PDF)](/assets/talks/2022-05-understanding-partial-failures.pdf)

<div class="video-container">
<script defer class="speakerdeck-embed" data-id="5355625a35c6442ba13defb06ff3f5d5" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div class="video-container">
<iframe src="https://www.youtube.com/embed/LACafAXKQ4Y" loading="lazy" frameborder="0" allowfullscreen></iframe>
</div>

### References

- Paper
  ["Understanding, Detecting and Localizing Partial Failures in Large System Software"](https://www.usenix.org/conference/nsdi20/presentation/lou)
- [Talk at NSDI 2020](https://youtu.be/FZj_5fNZfcI)
- [Post](https://blog.acolyer.org/2020/03/16/omega-gen/) from The Morning Paper blog

### Errata

Slides 5 and 6 showed incorrect failure hierarchy.
The correct hierarchy is ```Fail-Stop``` ⊂ ```Omission Failure``` ⊂ ```Fail-Recover``` ⊂ ```Byzantine Failure```.
Slides are updated, but video still contains incorrect slides.

See Chapter 2.2 "Abstracting Processes" from
[Introduction to Reliable and Secure Distributed Programming](https://www.distributedprogramming.net/) by Christian
Cachin, Rachid Guerraoui, Luís Rodrigues.

