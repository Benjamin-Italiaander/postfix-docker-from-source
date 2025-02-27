FROM debian:latest
LABEL maintainer="Benjamin Italiaander<benjamin@tlnd.nl>"
ARG POSTFIX_VERSION="3.10.1"
ARG POSTFIX_MIRROR="https://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/"
ARG DOMAIN="tlnd.nl"

# maildir or mbox type
ARG HOME_MAILBOX="Maildir/"


#COMPOSING THE FILE TO DOWNLOAD
ARG FETCH_FILE="${POSTFIX_MIRROR}postfix-${POSTFIX_VERSION}.tar.gz"

RUN set -e

# Install depend from default Repository
RUN apt update
RUN apt upgrade
 
RUN apt install --no-install-recommends --no-install-suggests -y wget ca-certificates

RUN apt install --no-install-recommends --no-install-suggests -y \
		curl \
                devscripts \
                equivs \
                git \
                libxml2-utils \
                lsb-release \
                xsltproc \
		ccache \
		cmake \
		build-essential \
		gperf \
		help2man \
		libreadline-dev \
		libssl-dev \
		libncurses-dev \
		libncursesw5-dev \
		ncurses-doc \
		zlib1g-dev \
		libsqlite3-dev \
		libmagic-dev \
		git \
		golang \
		pass \
		tree \
		nginx-core \
		net-tools \
		vim \
		sudo \
		apache2-utils \
		supervisor 

RUN apt install --no-install-recommends --no-install-suggests -y openssh-client git libffi-dev libghc-libffi-dev \
		python3-dev \
  		python3-certbot \
 		python3-certbot-nginx \
		build-essential \
		libdb-dev \
		m4 \
		libicu-dev \
		libnsl-dev \
		libsasl2-dev \
		libssl-dev \
		libpcre3-dev \
		libpcre2-dev \
		pkg-config \
		libcdb-dev \
		libsqlite3-dev \
		libpq-dev  \
		gnupg-utils  \
		gnupg2


RUN apt install --no-install-recommends --no-install-suggests -y openssh-client git libffi-dev libghc-libffi-dev \
	default-libmysqlclient-dev libglpk40

RUN /usr/sbin/groupadd -g 32 postfix
RUN /usr/sbin/groupadd -g 8434 postdrop
RUN /usr/sbin/useradd -c "Postfix Daemon User" -d /var/spool/postfix -g postfix -s /bin/false -u 32 postfix
#RUN chown -v postfix:postfix /var/mail
RUN  echo postfix.${DOMAIN}

# Donwnloading postfix from mirror given at the top of this file
RUN wget --no-check-certificate  ${FETCH_FILE}

# Extracting Postfix and removing tar file
RUN tar xf postfix-*.tar.gz
RUN rm ./postfix-*.tar.gz

# Build the binarys
WORKDIR /postfix-${POSTFIX_VERSION}

RUN cd /postfix-${POSTFIX_VERSION}
RUN make -f Makefile

# Install binarys to system
RUN chmod +x /postfix-3.10.1/postfix-install
RUN cd /postfix-${POSTFIX_VERSION}
RUN  /postfix-${POSTFIX_VERSION}/postfix-install -non-interactive

#Remove source files from image cleaning up a bit
RUN cd /
RUN rm -rf /postfix-${POSTFIX_VERSION}

# Some post install configurations 

RUN /usr/sbin/postconf -e 'home_mailbox= ${HOME_MAILBOX}' 

RUN echo "admin@${DOMAIN} root" > /etc/postfix/virtual

RUN postconf -e 'virtual_alias_maps= hash:/etc/postfix/virtual'

RUN /usr/sbin/postmap /etc/postfix/virtual





RUN mkdir -p /var/log/supervisor
COPY /supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 25
CMD ["/usr/bin/supervisord"]

