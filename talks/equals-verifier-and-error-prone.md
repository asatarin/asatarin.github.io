---
title: EqualsVerifier, ErrorProne and All the Others
description: Presented in Saint Petersburg in May 2018 at Heisenbug conference. Video and slides are in Russian.
layout: talk
---

Presented in Saint Petersburg in May 2018 at Heisenbug conference. Video and slides are in Russian.

### Abstract
Best kind of tests are ones that cost almost nothing, yet find defects. 
We’ll talk about two Java tools that are close to this ideal. 
First tool is [EqualsVerifier](http://jqno.nl/equalsverifier/) library, 
which helps with testing equals() and hashCode() contracts. 
The second tool is [ErrorProne](http://errorprone.info/) 
from Google — a compile-time checker for common mistakes in your code.

This talk will be useful for testers and Java developers.

<script async class="speakerdeck-embed" data-id="d8ba17b409c147aa8c59377ecf5d17ef" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

<div class="video-container">
<iframe src="https://www.youtube.com/embed/jeCpYOEuL64" frameborder="0" allowfullscreen></iframe>
</div>

### References
- [EqualsVerifier](http://jqno.nl/equalsverifier/)
- [“Not all equals methods are created equal”](https://youtu.be/pNJ_O10XaoM) by Jan Ouwens
- [How to Write an Equality Method in Java](https://www.artima.com/lejava/articles/equality.html)
- [How Do I Correctly Implement the equals() Method?](http://www.drdobbs.com/jvm/java-qa-how-do-i-correctly-implement-th/184405053)
- [Error Prone](http://errorprone.info/)
- [AutoValue](https://github.com/google/auto/blob/master/value/userguide/index.md) — Google way to create value objects
- [Immutables](https://immutables.github.io/) — Java annotation processor to create value objects and more
