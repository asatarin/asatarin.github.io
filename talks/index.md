---
title: Public Talks
description: Public talks and interviews given by Andrey Satarin on various tech subjects
---

{% assign all_talks = site.pages | where: "layout", "talk" | sort: "date" | reverse %}
{% assign border_year = "2021" %}

### English

<ul> 
  {% for post in all_talks %}
    {% assign year_published = post.date | date: '%Y' %}
    {% if year_published >= border_year %}
      <li>
        <a href="{{ site.baseurl }}{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y" }}) <br/>
      </li>
    {% endif %}
  {% endfor %}
</ul>

### Russian

<ul> 
  {% for post in all_talks %}
    {% assign year_published = post.date | date: '%Y' %}
    {% if year_published < border_year %}
      <li>
        <a href="{{ site.baseurl }}{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y" }}) <br/>
      </li>
    {% endif %}
  {% endfor %}
</ul>
