#!/bin/sh

echo Awesome Bot

echo awesome_bot --allow-dupe --allow-ssl --allow-redirect $(find /github/workspace/ -name "*.md")

awesome_bot --allow-dupe --allow-ssl --allow-redirect $(find /github/workspace/ -name "*.md")

echo Awesome Bot
