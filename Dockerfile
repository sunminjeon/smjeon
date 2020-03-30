FROM ubuntu:14.04
MAINTAINER harang.lee@samsung.com
##########################################



##########################################
#private configuration
COPY build_config /build_config
RUN    chmod 0644 /build_config/95proxies \
	&& chown root.root /build_config/95proxies \
	&& mv /build_config/95proxies /etc/apt/apt.conf.d/ \
	&& sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list \
	&& apt-get -qq update \
	&& apt-key add build_config/nginx_signing.key \
	&& echo 'deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx' >> /etc/apt/sources.list \
	&& cat /etc/apt/sources.list \
	&& apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -qqy install --no-install-recommends \
							ca-certificates \
							apt-transport-https \
							nginx \
							cron \
							openssl \
	&& rm -rf /var/lib/apt/lists/* 	\
	&& cp /build_config/SDS.crt /usr/local/share/ca-certificates/ \
    && mv /build_config/SDS.crt /usr/share/ca-certificates/ \
	&& update-ca-certificates --fresh
	&& 
##########################################

##########################################
#update ssi security config and remove private configuration file
RUN	chmod +x /build_config/ssi_security_setting.sh \
	&& /build_config/ssi_security_setting.sh \
	&& rm /usr/local/share/ca-certificates/SDS.crt \
	   /etc/apt/apt.conf.d/95proxies \
	&& rm -rf /build_config
##########################################
