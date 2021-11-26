---
title: All Posts
---

List of all the posts:
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}"> {{ post.title }} </a> ({{ post.date | date: "%B %Y"" }})
    </li>
  {% endfor %}
</ul>
