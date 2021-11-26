---
title: List of all the posts
---

{% assign begin_2022 = "2022-01-01" | date: '%s' %} 
{% assign begin_2021 = "2022-01-01" | date: '%s' %} 
{% assign begin_2020 = "2022-01-01" | date: '%s' %} 

### 2021
<ul>
  {% for post in site.posts %}
    {% assign date_as_str = post.date | date: '%s' %}
    {% if date_as_str >= begin_2021 and date_as_str < begin_2022 %}
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
    {% if date_as_str < begin_2021 %}
      <li>
        <a href="{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y"" }})
      </li>
    {% endif %}
  {% endfor %}
</ul>
