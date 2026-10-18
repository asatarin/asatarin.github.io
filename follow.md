---
title: How to Follow
description: How to follow me on the Internet
---

## Social Media Platforms

To follow me on other platforms, use one of these profiles:
<ul>
    {% for me_link in site.social.links -%}
    <li><a rel="me" href="{{ me_link }}">{{ me_link }}</a></li>
    {%- endfor %}
</ul>

## RSS / Atom

To follow the RSS / Atom feed of this website, you need a feed reader. I recommend [Feedly](https://feedly.com).
Add any website page or the Atom [feed]({{ '/feed.xml' | absolute_url }}) to Feedly. If neither works,
add the full feed URL `{{ '/feed.xml' | absolute_url }}` directly.
