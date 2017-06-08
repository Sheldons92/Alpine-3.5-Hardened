FROM alpine:3.5

RUN apk update && apk --no-cache add openjdk8-jre
RUN mv /usr/bin/java /usr/bin/java2
RUN chmod 755 /usr/bin/java

ADD harden.sh /usr/sbin/harden.sh
ADD harden2.sh /usr/sbin/harden2.sh
RUN chmod a+x /usr/sbin/harden.sh /usr/sbin/harden2.sh
RUN /usr/sbin/harden.sh

USER user


