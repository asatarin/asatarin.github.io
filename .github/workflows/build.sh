#!/bin/sh

set -e

# shellcheck disable=SC2046
awesome_bot \
  --white-list "www.amazon.com,dl.acm.org,docs.google.com,medium.com" \
  --allow 999 \
  --allow-dupe \
  --allow-redirect \
  $(find /github/workspace/ -name "*.md")
