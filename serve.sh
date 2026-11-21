#!/bin/sh
# Serve the site locally at http://localhost:4000 using Docker (no local Ruby needed).
# Gems are cached in the "qrcp-website-gems" volume so restarts are fast.
#
#   ./serve.sh          development build (no analytics)
#   ./serve.sh --prod   production build (JEKYLL_ENV=production, like GitHub Pages):
#                       renders the GoatCounter script; count.js still ignores localhost.
set -e
cd "$(dirname "$0")"
ENV=development
[ "$1" = "--prod" ] && ENV=production
TTY=""; [ -t 0 ] && TTY="-it"
exec docker run --rm $TTY --name qrcp-website \
  -e JEKYLL_ENV=$ENV \
  -v "$PWD":/srv/site -w /srv/site \
  -v qrcp-website-gems:/usr/local/bundle \
  -p 4000:4000 -p 35729:35729 \
  ruby:3.3 \
  sh -c "bundle install && bundle exec jekyll serve --host 0.0.0.0 --livereload --force_polling"
