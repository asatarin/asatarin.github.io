---
title: EqualsVerifier, ErrorProne and All the Others
description: Presented in Saint Petersburg in May 2018 at Heisenbug conference. Video and slides are in Russian.
date: 2018-05-18
image: /assets/thumbnails/2018-equals-verifier-and-error-prone.jpg
layout: talk
---

Presented in Saint Petersburg in May 2018
at [Heisenbug](https://heisenbug.ru/en/)
conference. Video and slides are in Russian.

### Abstract

Best kind of tests are ones that cost almost nothing, yet find defects.
We’ll talk about two Java tools that are close to this ideal.
First tool is [EqualsVerifier](http://jqno.nl/equalsverifier/) library,
which helps with testing equals() and hashCode() contracts.
The second tool is [ErrorProne](http://errorprone.info/)
from Google — a compile-time checker for common mistakes in your code.

This talk will be useful for testers and Java developers.

### Materials

[Download slides in Russian (PDF)](/assets/talks/2018-05-talk-equalsverifier-and-errorprone.pdf)

{% include speakerdeck.html
data_id = "d8ba17b409c147aa8c59377ecf5d17ef"
print_alt_url = "https://speakerdeck.com/asatarin/equalsverifier-errorprone-i-vsie-vsie-vsie-gieizienbagh-pitier-2018"
%}

{% include youtube.html video_id="jeCpYOEuL64" %}

### References

- [EqualsVerifier](http://jqno.nl/equalsverifier/)
- [“Not all equals methods are created equal”](https://youtu.be/pNJ_O10XaoM) by Jan Ouwens
- [How to Write an Equality Method in Java](https://www.artima.com/lejava/articles/equality.html)
- [How Do I Correctly Implement the equals() Method?](http://www.drdobbs.com/jvm/java-qa-how-do-i-correctly-implement-th/184405053)
- [Error Prone](http://errorprone.info/)
- [AutoValue](https://github.com/google/auto/blob/master/value/userguide/index.md) — Google way to create value objects
- [Immutables](https://immutables.github.io/) — Java annotation processor to create value objects and more
