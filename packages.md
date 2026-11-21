---
layout: default
title: Packages
permalink: /packages/
---

{% assign latest = site.categories.releases | where_exp: "r", "r.prerelease != true" | first %}
{% assign version = latest.version | default: "<version>" | remove_first: "v" %}

# Install qrcp

{% if latest %}Latest release: **[{{ latest.title }}]({{ latest.url | relative_url }})**, published {{ latest.date | date: "%B %-d, %Y" }}.{% endif %}

{% assign platforms = site.data.packages | group_by: "platform" %}
{% for group in platforms %}
## {{ group.name }}

| Package | Command |
|---------|---------|
{% for pkg in group.items %}| [{{ pkg.name }}]({{ pkg.url }}) | `{{ pkg.command | replace: "VERSION", version }}` |
{% endfor %}
{% endfor %}

## Prebuilt binaries

Download the archive for your platform from the <a href="https://github.com/claudiodangelis/qrcp/releases/latest" data-goatcounter-click="ext-binaries-latest">latest release</a>.

| Platform    | Instructions                                                                             |
|-------------|------------------------------------------------------------------------------------------|
| **Linux**   | Extract the `.tar.gz` archive, move the binary to `/usr/local/bin`, and set permissions. |
| **macOS**   | Extract the `.tar.gz` archive, move the binary to `/usr/local/bin`, and set permissions. |
| **Windows** | Extract the `.zip` archive and place the `.exe` file in a directory in your `PATH`.      |

## Confirm installation

```sh
qrcp --help
```
