ARG SNELL_VERSION=2.0.0-b9
ARG GLIBC_VERSION=2.29-r0

# get snell version
FROM alpine:3.11 as get-snell-version

ARG SNELL_VERSION

COPY parse-version.sh ./

RUN chmod +x ./parse-version.sh \
    && apk add bash

RUN ["/bin/bash", "-c", "./parse-version.sh"]

# runtime
FROM alpine:3.11

ARG GLIBC_VERSION

LABEL MAINTAINER="Xavier Niu"

ENV LANG=C.UTF-8

ENV PORT=8388
ENV PSK=
ENV OBFS=tls

COPY entrypoint.sh /usr/bin/
COPY --from=get-snell-version /snell-version ./

RUN echo "[INFO] Install glibc" \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -O glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && wget -O glibc-bin.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && apk add glibc.apk glibc-bin.apk \
    && apk add --no-cache libstdc++ \
    && rm -rf glibc.apk glibc-bin.apk /etc/apk/keys/sgerrand.rsa.pub /var/cache/apk/* \
    && echo "[INFO] Install snell" \
    && SNELL_URL=$(cat ./snell-version) \
    && echo "[INFO] SNELL_URL: ${SNELL_URL}" \
    && wget --no-check-certificate -O snell.zip ${SNELL_URL} \
    && unzip snell.zip \
    && rm -f snell.zip \
    && chmod +x snell-server \
    && mv snell-server /usr/bin/ \
    && chmod +x /usr/bin/entrypoint.sh

EXPOSE ${PORT}/tcp
EXPOSE ${PORT}/udp

ENTRYPOINT ["entrypoint.sh"]
