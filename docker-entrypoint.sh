#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Touch tmp/restart.txt to trigger a reload
touch tmp/restart.txt

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"