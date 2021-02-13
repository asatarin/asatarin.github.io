#!/bin/sh

set -e

awesome_bot --white-list "https://www.amazon.com" --allow 999 --allow-dupe --allow-redirect $(find /github/workspace/ -name "*.md")
