#!/bin/sh

echo Awesome Bot

awesome_bot --allow 999 --allow-dupe --allow-ssl --allow-redirect $(find . -name "/github/workspace/*.md")

echo Awesome Bot
