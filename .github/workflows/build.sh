#!/bin/sh

set -e

awesome_bot --allow 999 --allow-dupe --allow-redirect $(find /github/workspace/ -name "*.md")
