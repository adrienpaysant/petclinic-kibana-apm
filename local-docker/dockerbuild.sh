#!/bin/bash
cd "$(dirname "$0")"
set -e
export JAR_NAME="thejar"
# Check args
if [ "$#" -ne 2 ]; then
  echo "Missing args: $0 <image_name> <image_tag>"
  exit 1
fi

IMAGE_NAME="$1"
IMAGE_TAG="$2"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building java app"
cd ..
# now at the root folder
pwd
# Build the java app
mvn clean package -DskipTests -Dcheckstyle.skip
# Move jar to dockerbuild folder
# clean first
rm -rf local-docker/dockerbuild/*.jar
cp target/*.jar local-docker/dockerbuild/${JAR_NAME}.jar
#get into dockerbuild folder
cd local-docker/dockerbuild
pwd
# Fetch apm agent
curl -o elastic-apm-agent-1.45.0.jar https://repo1.maven.org/maven2/co/elastic/apm/elastic-apm-agent/1.45.0/elastic-apm-agent-1.45.0.jar
mv elastic-apm-agent-1.45.0.jar elastic-apm-agent.jar
# Build
echo "Building docker image $IMAGE_NAME..."
docker build -t ${FULL_IMAGE_NAME} --build-arg=JAR_NAME .
echo "Build done."
rm -f *.jar