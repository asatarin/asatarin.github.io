#!/bin/sh

set -e

awesome_bot \
  --white-list "www.amazon.com,dl.acm.org,docs.google.com,medium.com" \
  --allow 999 \
  --allow-dupe \
  --allow-redirect $(find /github/workspace/ -name "*.md")
