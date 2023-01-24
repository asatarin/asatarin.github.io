---
title: How to Fight Production Incidents?
description: >
  Talk on "How to fight production incidents?: an empirical study on a large-scale cloud service" paper for distributed systems reading group.
date: 2023-01-25
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

Slides TBD

Video TBD 

### References
 - "How to fight production incidents?: an empirical study on a large-scale cloud service" [paper](https://dl.acm.org/doi/10.1145/3542929.3563482)
 - [Slides](https://acmsocc.org/2022/assets/slides/95.pdf) for the talk presented at SOCC 2022 by the authors
 - Overview talk on [“Understanding and Detecting Software Upgrade Failures in Distributed Systems”](https://asatarin.github.io/talks/2022-09-upgrade-failures-in-distributed-systems/) paper
 - Overview talk on [“Understanding, Detecting and Localizing Partial Failures in Large System Software”](https://asatarin.github.io/talks/2022-05-understanding-partial-failures/) paper
 - Supriyo Ghosh [personal website](https://sites.google.com/site/supriyophdsmu/) and [Twitter](https://mobile.twitter.com/supriyo_ai)
 - Manish Shetty [personal website](https://manishshettym.github.io/) and [Twitter](https://mobile.twitter.com/slimshetty_)
 - Chetan Bansal [page](https://www.microsoft.com/en-us/research/people/chetanb/) on Microsoft Research website
 - Suman Nath [page](https://www.microsoft.com/en-us/research/people/sumann/) on Microsoft Research website
