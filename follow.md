---
title: How to Follow
description: How to follow me on the Internet
---

### RSS / Atom

To follow RSS / Atom feed on this website you need a feed reader. I recommend [Feedly](https://feedly.com).
Add any website page or Atom [feed]({{ '/feed.xml' | absolute_url }}) to Feedly, if neither works,
add full feed URL `{{ '/feed.xml' | absolute_url }}` directly.

### Other Platforms

To follow me on other platforms use one of the profiles:
<ul>
    {% for me_link in site.social.links -%}
    <li><a rel="me" href="{{ me_link }}">{{ me_link }}</a></li>
    {%- endfor %}
</ul>
