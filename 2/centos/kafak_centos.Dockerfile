From docker.io/amd64/centos:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
  OS_ARCH="amd64" \
  OS_FLAVOUR="debian-10" \
  OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

RUN dnf update -y
COPY prebuildfs /
# Install required system packages and dependencies
# RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.13-1" --checksum cf2e298428d67fb30c376ee6638c055afe54cc1f282bab314abc53a34c37be44
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-5" --checksum 1e34030c18f0ec2467fa5f1b1fbad24add217f671c3a61628f7b8671391f9676
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-5" --checksum 9e312b4a7e16a55d08e67c4fd69c91000e4dcc4af149d59915c49375b83852af
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kafka" "2.8.1-1" --checksum 29c5bed69d744e107c2a473947b83222e614b452b7b3cf881834be044d535786
# RUN apt-get update && apt-get upgrade -y && \
#   rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/kafka/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/kafka/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/kafka/postunpack.sh
ENV BITNAMI_APP_NAME="kafka" \
  BITNAMI_IMAGE_VERSION="2.8.1-debian-10-r105" \
  JAVA_HOME="/opt/bitnami/java" \
  PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kafka/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kafka/run.sh" ]
