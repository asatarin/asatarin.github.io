---
title: How to Follow
description: How to follow me on the Internet
---

### RSS / Atom

To follow RSS / Atom feed on this website you need a feed reader. I recommend [Feedly](https://feedly.com).
Add any page on the website to Feedly or use Atom [feed]({{ '/feed.xml' | absolute_url }}), if neither works,
copy full URL `{{ '/feed.xml' | absolute_url }}`

### Other Platforms

To follow me on other platforms use one of the profiles below:
<ul>
    {% for me_link in site.social.links -%}
    <li><a rel="me" href="{{ me_link }}">{{ me_link }}</a></li>
    {%- endfor %}
</ul>
