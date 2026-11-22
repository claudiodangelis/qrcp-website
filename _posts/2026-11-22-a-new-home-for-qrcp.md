---
title: "A new home for qrcp"
description: "qrcp.sh is now a full website, with docs, packages, tutorials and news."
date: 2026-11-22 09:00:00 +0100
---

Until a few days ago, qrcp.sh was a single page built from the `docs/` folder of the main repository: a copy of the README, really. Today it's a website of its own.

<!--more-->

## What's new

- **A homepage** that shows what qrcp does at a glance: what it is, how it works, how to install it.
- **[Docs]({{ '/docs/' | relative_url }})**: every command, flag and configuration option in one place, with use cases and a troubleshooting guide.
- **[Packages]({{ '/packages/' | relative_url }})**: how to install qrcp on every platform, from Homebrew and the AUR to winget, Scoop, Debian and Fedora packages, or plain binaries.
- **[Tutorials]({{ '/tutorials/' | relative_url }})**: step-by-step guides, starting with [secure transfers with mkcert]({{ '/tutorials/secure-transfers-with-mkcert/' | relative_url }}). More are coming, some with videos.
- **[News]({{ '/news/' | relative_url }})**: articles like this one, and a post for every release, all the way back to 0.4.1.

## Follow along

Every post, articles and releases alike, is in the [RSS feed]({{ '/feed.xml' | relative_url }}). Add it to your feed reader and you'll know when a new version is out.

## Privacy

The site uses [GoatCounter](https://www.goatcounter.com) to count visits: it sets no cookies and stores no personal data, so there's no consent banner to click through.

## Behind the scenes

The site lives in its own repository, [claudiodangelis/qrcp-website](https://github.com/claudiodangelis/qrcp-website), and is built with Jekyll on GitHub Pages. Found a typo, or want to write a tutorial? Pull requests are welcome.
