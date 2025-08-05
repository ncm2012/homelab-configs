#!/bin/bash

# Define the log file search string
ERROR_STRING="ERR failed to connect to an HTTPS backend"

# Define the container name to monitor
CONTAINER_NAME="cloudflared"

while true; do
  echo "Checking logs for container: $CONTAINER_NAME..."

  # Get the last 50 lines of logs from the container
  # Using `docker logs` requires access to the Docker socket.
  if docker logs "$CONTAINER_NAME" --since 5m --tail 50 | grep -q "$ERROR_STRING"; then
    echo "ERROR DETECTED! Restarting container: $CONTAINER_NAME"
    docker restart "$CONTAINER_NAME"
    echo "Restart command sent."
  else
    echo "No errors found."
  fi

  # Wait for 60 seconds before checking again
  sleep 60
done
