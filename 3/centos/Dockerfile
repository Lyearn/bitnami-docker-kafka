From docker.io/amd64/centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

RUN yum install -y epel-release

COPY prebuildfs /
# Install required system packages and dependencies
# RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN yum install -y acl ca-certificates curl gzip libc6 procps-ng tar zlib

RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.6-13" --checksum 3a0612ea050c5d325c0dffde428e72c0c1b507701c47c8319791f6c791d9d590
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.5-13" --checksum dab235943ca051d1f7591cbb5c926dddcde4357f2755826e5587b0e94c0f017e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "17.0.8-7-5" --checksum 80df56a85606d2519b6bbe2afbbca700f71cd0cb17bb67a3b26eaa9db7597898
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kafka" "3.5.1-2" --checksum b3353f6bfad93db4634283f6febbca80ee9dca486189e6f4005e38a12769ace7

RUN yum update -y && yum upgrade -y && \
    yum clean all && rm -fR /var/cache/yum

RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/kafka/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/kafka/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/kafka/postunpack.sh
ENV BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="3.5.1-debian-11-r27" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kafka/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kafka/run.sh" ]
