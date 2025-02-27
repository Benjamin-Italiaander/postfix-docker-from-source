FROM debian:latest
LABEL maintainer="Benjamin Italiaander<benjamin@tlnd.nl>"

RUN set -e
RUN apt update 
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
		wget  \
		pass \
		qrencode \
		tree \
		wl-clipboard \
		xclip \
		radicale \
		nginx-core \
		net-tools \
		vim \
		sudo \
		apache2-utils \
		zsh \
		openssh-server \
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

# Downloading Postfix 3.10.1 current stable release (Feb 2025)
RUN wget https://high5.nl/mirrors/postfix-release/official/postfix-3.10.1.tar.gz
# RUN wget https://high5.nl/mirrors/postfix-release/official/postfix-3.10.1.tar.gz.sig

# Extracting Postfix
RUN tar xf postfix-*.tar.gz
RUN rm ./postfix-*.tar.gz

# Build the make
WORKDIR /postfix-3.10.1

RUN cd /postfix-3.10.1
RUN make -f Makefile

# Install to system
RUN chmod +x /postfix-3.10.1/postfix-install
RUN cd /postfix-3.10.1
RUN  /postfix-3.10.1/postfix-install -non-interactive

RUN mkdir -p /var/log/supervisor
COPY /supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 25
CMD ["/usr/bin/supervisord"]
