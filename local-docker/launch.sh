#!/bin/bash
# Change to the script's directory
cd "$(dirname "$0")"
set -e

IMAGE_NAME="local-petclinic"
IMAGE_TAG="1"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
# Default variables
FORCE_BUILD=false

# Function to display usage
usage() {
  echo "Usage: $0 [-f] <image_name> <image_tag>"
  echo "  -f    Force the build of the Docker image"
  exit 1
}

# Parse command-line options
while getopts ":f" opt; do
  case ${opt} in
  f)
    FORCE_BUILD=true
    ;;
  \?)
    usage
    ;;
  esac
done
shift $((OPTIND - 1))

# Check if the image exists or if the build should be forced
if [[ "$(docker images -q $FULL_IMAGE_NAME 2>/dev/null)" == "" || "$FORCE_BUILD" == "true" ]]; then
  echo "The image $FULL_IMAGE_NAME does not exist or a forced build is requested. Executing dockerbuild.sh."
  # Execute the build script
  ./dockerbuild.sh $IMAGE_NAME $IMAGE_TAG
else
  echo "The image $FULL_IMAGE_NAME already exists and no forced build is requested."
fi

# Green light Docker Compose
echo "Starting Docker Compose..."
docker-compose up
