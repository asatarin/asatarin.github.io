#!/bin/sh

set -e

echo awesome_bot --allow-dupe --allow-ssl --allow-redirect $(find /github/workspace/ -name "*.md")

awesome_bot --allow-dupe --allow-ssl --allow-redirect $(find /github/workspace/ -name "*.md")

