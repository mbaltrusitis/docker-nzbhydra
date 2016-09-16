FROM ubuntu:16.04
MAINTAINER Matthew Baltrusitis <matthew@baltrusitis.com

ENV DEBIAN_FRONTEND="noninteractive"

ENV APP_DIR=/opt/nzbhydra
ENV APP_SRC=$APP_DIR/src
ENV APP_DATA=$APP_DIR/data

RUN mkdir -p "${APP_SRC}" "${APP_DATA}" \
	&& apt-get -qy update \
	&& apt-get install -qy --fix-missing \
		git \
		python \
		python-pip \
	&& cd "${APP_DIR}" \
	&& git clone https://github.com/theotherp/nzbhydra.git "${APP_SRC}" \
	&& rm -fr /tmp/*


VOLUME ["${APP_DATA}"]

CMD ["python", "/opt/nzbhydra/src/nzbhydra.py", "--config=/opt/nzbhydra/data/nzbhydra.config", "--database=/opt/nzbhydra/data/nzbhydra.db", "--logfile=/opt/nzbhydra/data/nzbhydra.log", "--no-browser"]
