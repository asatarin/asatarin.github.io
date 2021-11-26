---
title: All Posts
---

List of all the posts:
### 2021

<ul>
  {% for post in site.posts %}
    {% assign date_as_str = post.date | date: '%s' %}
    {% if date_as_str >= "2021-01-01" and date_as_str < "2022-01-01" %}
      <li>
        <a href="{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y"" }})
      </li>
    {% endif %}
  {% endfor %}
</ul>

### 2020
<ul>
  {% for post in site.posts %}
    {% assign date_as_str = post.date | date: '%s' %}
    {% if date_as_str < "2021-01-01" %}
      <li>
        <a href="{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y"" }})
      </li>
    {% endif %}
  {% endfor %}
</ul>
