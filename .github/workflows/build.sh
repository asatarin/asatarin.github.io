#!/bin/sh

echo Awesome Bot

echo awesome_bot --allow-dupe --allow-ssl --allow-redirect $(find . -name "/github/workspace/*.md")

awesome_bot --allow-dupe --allow-ssl --allow-redirect $(find . -name "/github/workspace/*.md")

echo Awesome Bot
