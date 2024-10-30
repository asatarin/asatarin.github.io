---
title: Wash Your Hands Before You Eat, or Sanitizers in Testing
description: Presented in Saint-Petersburg in June 2017 at Heisenbug conference. Video and slides are in Russian.
date: 2017-07-04
image: /assets/thumbnails/2017-sanitizers-in-testing.jpg
layout: talk
---

Presented in Saint-Petersburg in June 2017 at [Heisenbug](https://heisenbug.ru/en/) conference. Video and slides are in
Russian.

### Materials

[Download slides in Russian (PDF)](/assets/talks/2017-07-talk-sanitizers-in-testing.pdf)

{% include speakerdeck.html
slide = "2" data_id = "bcb48dac52af45049d477d8ab9d4b389"
print_alt_url = "https://speakerdeck.com/asatarin/moitie-ruki-pieried-iedoi-ili-sanitaiziery-v-tiestirovanii"
%}

{% include youtube.html video_id="Aeu7abIKgGs" %}

### Abstract

As the saying goes, “with great power comes great responsibility”.
C++ is a language with great expression power and vast capabilities.
One have to pay for these capabilities with possible defects,
which are absent in programs written in managed languages.

Sanitizers are wonderful tools, which will help you find complex
defects in C++ programs. I’ll talk about these tools,
what they can do, and how to use them in your project.

### References

- ["AddressSanitizer: A Fast Address Sanity Checker"](https://scholar.google.ru/scholar?cluster=2096653874509075773&hl=en&as_sdt=0,5)
- ["MemorySanitizer: fast detector of uninitialized memory use in C++"](https://scholar.google.ru/scholar?cluster=3033949213014053600&hl=en&as_sdt=0,5)
- ["ThreadSanitizer: data race detection in practice"](https://scholar.google.ru/scholar?cluster=14589555155353882213&hl=en&as_sdt=0,5)
- [https://github.com/google/sanitizers](https://github.com/google/sanitizers)
- [AddressSanitizer, или как сделать программы на C/С++ надежнее и безопаснее, Константин Серебряный](https://youtu.be/vKtNwALHb2k)—
  talk on AddressSanitizer by Konstantin Serebryany at HighLoad 2012 in Moscow (in Russian)
- [""go test -race" Under the Hood"](https://youtu.be/5erqWdlhQLA) by Kavya Joshi — explanation of "go race" which is
  based on ThreadSanitizer, presented at StrangeLoop 2016
- [Konstantin Serebryany](https://research.google.com/pubs/KonstantinSerebryany.html) page at Google Research
