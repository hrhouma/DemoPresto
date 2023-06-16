FROM openjdk:8-jre-alpine

RUN apk update \
    && apk add bash \
    && apk add wget \
    && apk add nano \
    && apk add snappy \
    && apk add util-linux \
    && apk add python

WORKDIR /usr/local

RUN wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.234.2/presto-server-0.234.2.tar.gz \
    && tar -xvf presto-server-0.234.2.tar.gz

RUN cd "/usr/local/presto-server-0.234.2" && mkdir -p etc/catalog

COPY config/config-coordinator.properties /usr/local/presto-server-0.234.2/etc
COPY config/config-worker.properties /usr/local/presto-server-0.234.2/etc
COPY config/jvm.config /usr/local/presto-server-0.234.2/etc
COPY config/log.properties /usr/local/presto-server-0.234.2/etc
COPY config/node.properties /usr/local/presto-server-0.234.2/etc
COPY config/catalog/my_hive.properties /usr/local/presto-server-0.234.2/etc/catalog

RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.473/aws-java-sdk-1.11.473.jar -P /usr/local/presto-server-0.234.2/lib
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.6.5/hadoop-aws-2.6.5.jar -P /usr/local/presto-server-0.234.2/lib

EXPOSE 8090 8090

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]