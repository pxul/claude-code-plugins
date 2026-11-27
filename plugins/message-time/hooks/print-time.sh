#!/bin/sh
# Prints the local time, day and date, so a session can tell when each
# message arrived.

LC_ALL=C date '+Time: %H:%M, %A %-d %B %Y'
