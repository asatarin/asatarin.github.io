---

# @formatter:off
title: Evolution of Cloud Block Store
description: >
  Talk on "What's the Story in EBS Glory: Evolutions and Lessons in Building Cloud Block Store" paper for distributed
  systems reading group.
date: 2024-05-02
layout: talk
image: /assets/thumbnails/2024-05-evolution-of-cloud-block-store.png
# @formatter:on
---

This is a talk on "What's the Story in EBS Glory: Evolutions and Lessons in Building Cloud Block Store"
paper for [distributed systems reading group](http://charap.co/category/reading-group/) lead
by [Aleksey Charapko](https://twitter.com/AlekseyCharapko).

### Paper

"What's the Story in EBS Glory: Evolutions and Lessons in Building Cloud Block Store" by Weidong Zhang, Erci Xu, Qiuping
Wang, Xiaolu Zhang, Yuesheng Gu, Zhenwei Lu, Tao Ouyang, Guanqun Dai, Wenwen Peng, Zhe Xu, Shuo Zhang, Dong Wu, Yilei
Peng, Tianyun Wang, Haoran Zhang, Jiasheng Wang, Wenyuan Yan, Yuanyuan Dong, Wenhui Yao, Zhongjie Wu, Lingjun Zhu, Chao
Shi, Yinhu Wang, Rong Liu, Junping Wu, Jiaji Zhu, and Jiesheng Wu, Alibaba Group.

Paper presented at [FAST 2024](https://www.usenix.org/conference/fast24/technical-sessions).

#### Paper Abstract

In this paper, we qualitatively and quantitatively discuss the design choices, production experience, and lessons in
building the Elastic Block Storage (EBS) at Alibaba Cloud over the past decade. To cope with hardware advancement and
users' demands, we shift our focus from design simplicity in EBS1 to high performance and space efficiency in EBS2, and
finally reducing network traffic amplification in EBS3.

In addition to the architectural evolutions, we also summarize the lessons and experiences in development as four
topics, including: (i) achieving high elasticity in latency, throughput, IOPS and capacity; (ii) improving availability
by minimizing the blast radius of individual, regional, and global failure events; (iii) identifying the motivations and
key tradeoffs in various hardware offloading solutions; and (iv) identifying the pros/cons of the alternative solutions
and explaining why seemingly promising ideas would not work in practice.

### Materials

[Download slides (PDF)](/assets/talks/2024-05-evolution-of-cloud-block-store.pdf)

{% include speakerdeck.html
data_id = "8216f588ffd84b66a6fd545b6adb0f1a"
print_alt_url = "https://speakerdeck.com/asatarin/evolution-of-cloud-block-store"
%}

Video TBD.

### References

- "What's the Story in EBS Glory: Evolutions and Lessons in Building Cloud Block
  Store" [paper](https://www.usenix.org/conference/fast24/presentation/zhang-weidong)
- ["What's the Story in EBS Glory"](https://youtu.be/37X8vCuLDRg) presentation video
  from [FAST 2024](https://www.usenix.org/conference/fast24/technical-sessions)
- [More Than Capacity: Performance-oriented Evolution of Pangu in Alibaba](https://www.usenix.org/conference/fast23/presentation/li-qiang-deployed) —
  distributed file system Pangu is used as a foundation for EBS in Alibaba Cloud
- [Formal Methods at Amazon S3](2022-02-formal-methods-at-amazon-s3.md) — I gave an overview talk on one of the papers
  referenced
- [Millions of Tiny Databases](https://www.usenix.org/conference/nsdi20/presentation/brooker) — paper on AWS EBS control
  plane configuration database
