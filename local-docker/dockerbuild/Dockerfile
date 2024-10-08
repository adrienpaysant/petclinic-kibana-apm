FROM openjdk:17.0.2 
ARG JAR_NAME

ENV JAR_NAME=$JAR_NAME

RUN useradd -m -d /opt/${JAR_NAME} -u 1000 ${JAR_NAME}
USER ${JAR_NAME}

WORKDIR /opt/${JAR_NAME}

COPY ${JAR_NAME}.jar /opt/${JAR_NAME}/
COPY application.properties /opt/${JAR_NAME}/application.properties
COPY elastic-apm-agent.jar /etc/apm/
ENTRYPOINT [ "sh", "-c", "java -javaagent:/etc/apm/elastic-apm-agent.jar -Delastic.apm.server_urls=http://host.docker.internal:8200 -jar /opt/${JAR_NAME}/${JAR_NAME}.jar" ]
