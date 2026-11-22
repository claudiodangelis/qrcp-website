---
layout: default
title: News
permalink: /news/
redirect_from:
  - /releases/
---

# News

Articles about qrcp and every release, newest first. Subscribe via [RSS]({{ '/feed.xml' | relative_url }}) to get new posts.

<ul class="news-list">
{% for post in site.posts %}
  {% assign is_release = false %}{% if post.categories contains "releases" %}{% assign is_release = true %}{% endif %}
  <li>
    <span class="date">{{ post.date | date: "%Y-%m-%d" }}</span>
    <span class="tag{% if is_release %} tag-release{% endif %}">{% if is_release %}Release{% else %}Article{% endif %}</span>
    <a href="{{ post.url | relative_url }}">{% if is_release %}qrcp {% endif %}{{ post.title }}</a>
    {% if post.prerelease %}<em>(pre-release)</em>{% endif %}
    {% unless is_release %}{% if post.description %}<div class="summary">{{ post.description }}</div>{% endif %}{% endunless %}
  </li>
{% endfor %}
</ul>
