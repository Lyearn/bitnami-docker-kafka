From docker.io/amd64/centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
  OS_ARCH="amd64" \
  OS_FLAVOUR="debian-11" \
  OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

RUN yum install -y epel-release

COPY prebuildfs /
COPY kafka-2.7.2-linux-amd64-debian-10.tar.gz /
# Install required system packages and dependencies
# RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN yum install -y acl ca-certificates curl gzip libc6 procps-ng tar zlib

RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-1" --checksum 6d176a8b3c894c608106fee2cf10aaf3771015defb0b7e08fe60ce6c9c1cd342
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-152" --checksum 0694ae67645c416d9f6875e90c0f7cef379b4ac8030a6a5b8b5cc9ca77c6975d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-151" --checksum 9690a34674f152e55c71a55275265314ed1bb29e0be8a75d7880488509f70deb
RUN tar --directory "/opt/bitnami" --extract --gunzip --file "kafka-2.7.2-linux-amd64-debian-10.tar.gz" --no-same-owner --strip-components=2

RUN yum update -y && yum upgrade -y && \
    yum clean all && rm -fR /var/cache/yum

RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/kafka/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/kafka/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/kafka/postunpack.sh
ENV BITNAMI_APP_NAME="kafka" \
  BITNAMI_IMAGE_VERSION="2.7.2-debian-11-r124" \
  JAVA_HOME="/opt/bitnami/java" \
  PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/kafka/bin:$PATH"

RUN rm -rf kafka-2.7.2-linux-amd64-debian-10.tar.gz

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kafka/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kafka/run.sh" ]
