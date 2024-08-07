---

# @formatter:off
title: Formal Methods at Amazon S3
description: >
  Presentation on "Using Lightweight Formal Methods to Validate a Key-Value Storage Node in Amazon S3" paper for
  distributed systems reading group.
date: 2022-02-02
image: /assets/thumbnails/2022-02-formal-methods-at-amazon-s3.jpg
layout: talk
# @formatter:on
---

{% comment %}
Comments and feedback for the talk https://docs.google.com/document/d/1k0MLqGJOKMozLoWKEvPwXCzOiTRuMd9Orw9zT0eDpic/edit#
{% endcomment %}

This is a talk on "Using Lightweight Formal Methods to Validate a Key-Value Storage Node in Amazon S3"
paper for distributed systems [reading group](https://charap.co/category/reading-group/)
lead by [Aleksey Charapko](https://twitter.com/AlekseyCharapko).

### Paper

"Using lightweight formal methods to validate a key-value storage node in Amazon S3"
by James Bornholt, Rajeev Joshi, Vytautas Astrauskas, Brendan Cully, Bernhard Kragl,
Seth Markle, Kyle Sauri, Drew Schleit, Grant Slatton, Serdar Tasiran, Jacob Van Geffen,
Andrew Warfield. Presented at [SOSP 2021](https://dl.acm.org/doi/abs/10.1145/3477132.3483540).

#### Paper Abstract

This paper reports our experience applying lightweight formal methods to validate the correctness
of ShardStore, a new key-value storage node implementation for the Amazon S3 cloud object storage service.
By "lightweight formal methods" we mean a pragmatic approach to verifying the correctness
of a production storage node that is under ongoing feature development by a full-time engineering team.
We do not aim to achieve full formal verification, but instead emphasize automation, usability,
and the ability to continually ensure correctness as both software and its specification evolve over time.
Our approach decomposes correctness into independent properties, each checked by the most appropriate tool,
and develops executable reference models as specifications to be checked against the implementation.
Our work has prevented 16 issues from reaching production, including subtle crash consistency and
concurrency problems, and has been extended by non-formal-methods experts to check new
features and properties as ShardStore has evolved.

### Materials

[Download slides (PDF)](/assets/talks/2022-02-formal-methods-at-amazon-S3.pdf)

{% include speakerdeck.html
data_id = "3b0d36b7552f4643b240cc599491e25b"
print_alt_url = "https://speakerdeck.com/asatarin/formal-methods-at-amazon-s3"
%}

{% include youtube.html video_id="fAYNN2MmOvk" %}

### References

- "Using lightweight formal methods to validate a key-value storage node in Amazon S3"
  [paper](https://dl.acm.org/doi/abs/10.1145/3477132.3483540)
- [Reading Group. Using Lightweight Formal Methods to Validate a Key-Value Storage Node in Amazon S3](https://charap.co/reading-group-using-lightweight-formal-methods-to-validate-a-key-value-storage-node-in-amazon-s3/)
  blog post from [Aleksey Charapko](https://charap.co/about-me/) on the reading group meeting
- [Testing Distributed Systems](/testing-distributed-systems/) — if you are interested
  in approaches to testing distributed systems, there is curated list I maintain
- [Talk](https://youtu.be/YdxvOPenjWI) at SOSP 2021
- [Blog post](https://muratbuffalo.blogspot.com/2021/10/using-lightweight-formal-methods-to.html) on the paper
  from [Murat Demirbas](https://twitter.com/muratdemirbas)

### Transcript

{% include transcript.html filename="2022-02-formal-methods-at-amazon-s3.transcript.md" %}
