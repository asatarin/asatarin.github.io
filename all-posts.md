List of all the posts:
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.date }} {{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
