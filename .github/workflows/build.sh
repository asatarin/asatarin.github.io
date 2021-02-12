#!/bin/sh

set -e

awesome_bot --allow 999 --allow-dupe --allow-ssl --allow-redirect $(find /github/workspace/ -name "*.md")
