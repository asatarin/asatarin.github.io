---
title: List of all the posts
---

### 2021
<ul>
  {% for post in site.posts %}
    {% assign date_as_str = post.date | date: '%Y' %}
    {% if date_as_str >= "2021" and date_as_str < "2022" %}
      <li>
        <a href="{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y"" }}) <br/>
        <p> {{ post.description }} </p>
        {% if post.snippet %}
          <br/> <p> {{ post.snippet }} </p>
        {% endif %}
      </li>
    {% endif %}
  {% endfor %}
</ul>

### 2020
<ul>
  {% for post in site.posts %}
    {% assign date_as_str = post.date | date: '%Y' %}
    {% if date_as_str < "2021" %}
      <li>
        <a href="{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y"" }}) <br/>
        <p> {{ post.description }} </p>
      </li>
    {% endif %}
  {% endfor %}
</ul>
