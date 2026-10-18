---
title: Public Talks
description: Public talks and interviews given by Andrey Satarin on various tech subjects.
image: /assets/thumbnails/thumbnail-talks.webp
---

{% assign all_talks = site.pages | where: "layout", "talk" | sort: "date" | reverse %}
{% assign russian_talks = all_talks | where: "talk_language", "ru" %}
{% assign english_talks = all_talks | where_exp: "post", "post.talk_language != 'ru'" %}

## English

<ul> 
  {%- for post in english_talks %}
      <li>
        <a href="{{ post.url | relative_url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y" }}) <br/>
      </li>
  {%- endfor %}
</ul>

## Russian

<ul> 
  {%- for post in russian_talks %}
      <li>
        <a href="{{ post.url | relative_url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y" }}) <br/>
      </li>
  {%- endfor %}
</ul>
