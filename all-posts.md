List of all the posts:
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}"> {{ post.date | date_to_rfc822 }} {{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
