---
title: How to Check a System Without Running It
description: Presented in Moscow in December 2017 at Heisenbug conference. Video and slides are in Russian.
date: 2017-12-08
image: /assets/thumbnails/2017-how-to-check-a-system-without-running-it.jpg
layout: talk
---

Presented in Moscow in December 2017
at [Heisenbug](https://heisenbug.ru/en/) conference. Video and slides are
in Russian.

### Abstract

Every day the systems which we develop become more and more complicated.
It seems there is nowhere to hide from the ubiquitous complexity.
One of its aspects is configuration. On the one hand, configuration
has a significant influence on stability and availability of a system.
On the other hand, there is too little time set aside for checking its
correctness. In this talk, we'll explain how we test configuration and
how far it was useful for our project.

This talk will be helpful for those who want to learn an easy way to
increase system stability and availability in production.

[Download slides in Russian (PDF)](/assets/talks/2017-12-talk-how-to-check-a-system-without-running-it.pdf)

{% include speakerdeck.html
slide="2" data_id="19ab7d275dd446b38197481cb7541961"
print_alt_url = "https://speakerdeck.com/asatarin/kak-provierit-sistiemu-nie-zapuskaia-ieio-gieizienbagh-2017"
%}

{% include youtube.html video_id="KaeEjsAjV6A" %}

### References

- [Three days that shocked us in 2013](https://habrahabr.ru/company/odnoklassniki/blog/268413/) in Russian
- ["Paxos Made Live – An Engineering Perspective"](https://blog.acolyer.org/2015/03/05/paxos-made-live/)
- ["Early detection of configuration errors to reduce failure damage"](https://blog.acolyer.org/2016/11/29/early-detection-of-configuration-errors-to-reduce-failure-damage/)
- [Gixy — open source tool from Yandex to make your Nginx configuration safe](https://habrahabr.ru/company/yandex/blog/327590/)
  in Russian
- ["Configuration testing for Java developers: a case study"](https://youtu.be/Tk_nmV-mWOA) — talk
  by [Ruslan Cheremin](https://twitter.com/dj_begemot) on practical application of these ideas implemented in Java (in
  Russian). Full talk [transcript](https://habr.com/company/jugru/blog/427487/)
  and [slides](https://assets.ctfassets.net/ut4a3ciohj8i/HcZWuiIEg0ESicwEGWQM0/d0d76e5edb016747d1a6a3fba032ddb2/_______________________________________________________________________________________________-__________________________.pdf) are also published (in Russian).
