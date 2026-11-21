---
layout: default
title: Releases
permalink: /releases/
---

# Releases

Every qrcp release, newest first. Subscribe via [RSS]({{ '/feed.xml' | relative_url }}) to get notified about new versions.

<ul class="release-list">
{% for post in site.categories.releases %}
  <li>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <span class="date">{{ post.date | date: "%Y-%m-%d" }}</span>
    {% if post.prerelease %}<em>(pre-release)</em>{% endif %}
  </li>
{% endfor %}
</ul>
