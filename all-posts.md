List of all the posts:
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}"> {{ page.date | date_to_long_string: "ordinal" }} — {{ post.title }}</a>
    </li>
    <li>
      <a href="{{ post.url }}"> {{ post.date | date_to_long_string }} {{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
