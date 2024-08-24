#!/bin/bash

# Name of this script
SCRIPT_NAME="docker_cleanup.sh"

# Full path to this script
SCRIPT_PATH="$(realpath "$0")"

# Content of the cron job
CRON_JOB="0 */2 * * * $SCRIPT_PATH cleanup"

# Docker cleanup function
cleanup_docker() {
  echo "Starting Docker cleanup..."

  # Remove stopped containers
  docker container prune -f

  # Remove unused images
  docker image prune -a -f

  # Remove unused volumes
  docker volume prune -f

  # Remove unused networks
  docker network prune -f

  echo "Docker cleanup completed."
}

# Add cron job
add_cron_job() {
  (
    crontab -l 2>/dev/null
    echo "$CRON_JOB"
  ) | crontab -
  echo "Cron job added to run the script every 2 hours."
}

# Check and execute command
if [ "$1" = "cleanup" ]; then
  cleanup_docker
elif [ "$1" = "install" ]; then
  add_cron_job
else
  echo "Usage: $SCRIPT_NAME [install|cleanup]"
  echo "  install: Add cron job"
  echo "  cleanup: Run Docker cleanup immediately"
fi
