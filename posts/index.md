---
title: Posts
description: Posts on various subjects.
image: /assets/thumbnails/thumbnail-talks.png
---

# @formatter:off
{% assign all_posts = site.pages | where: "layout", "post" | where_exp: "post", "post.draft != true" | sort: "date" | reverse %}
# @formatter:on

<ul> 
  {%- for post in all_posts -%}
    {%- assign year_published = post.date | date: '%Y' -%}
      <li>
        <a href="{{ post.url | relative_url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y" }}) <br/>
      </li>
  {%- endfor %}
</ul>
