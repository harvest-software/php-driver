FROM public.ecr.aws/ubuntu/ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

# Base
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      cmake \
      git \
      libuv1-dev \
      devscripts \
      debhelper \
      dh-exec \
      libssl-dev \
      libz-dev \
      php8.1-dev \
      dh-php \
      libgmp-dev \
      apt-transport-s3 \
      gnupg-agent \
      ca-certificates \
      curl \
      gnupg \
      lsb-release ;

# Connect to our repo
ARG AWS_DEFAULT_REGION
ARG AWS_S3_ACCESS_KEY_ID
ARG AWS_S3_SECRET_ACCESS_KEY

RUN set -eux; \
    apt-get update; \
	  apt-get install -y --no-install-recommends \
        apt-transport-s3 \
        gnupg-agent \
        ca-certificates ;

RUN set -eux; \
  printf "AccessKeyId = %s\nSecretAccessKey = %s\nRegion = %s" $AWS_S3_ACCESS_KEY_ID $AWS_S3_SECRET_ACCESS_KEY $AWS_DEFAULT_REGION > /etc/apt/s3auth.conf \
  && curl https://harvest-package-repo.s3.ap-southeast-2.amazonaws.com/home/public/repo_signing.key | apt-key add - \
  && echo "deb [trusted=yes] s3://harvest-package-repo/ubuntu jammy stable/main stable/contrib" > /etc/apt/sources.list.d/harvest-jammy.list


RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    cassandra-cpp-driver-dev ;

COPY entrypoint.sh /entrypoint.sh
RUN chmod -v +x /entrypoint.sh

CMD ["/entrypoint.sh"]
