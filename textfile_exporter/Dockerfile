FROM debian:bookworm

LABEL maintainer="Kristoffer Ek <stoffer@skulp.net>"

# Enable non-free repo (needed for some packages)
RUN echo "deb http://http.us.debian.org/debian bookworm non-free" >> /etc/apt/sources.list

# Install dependencies including mbtget build tools
RUN apt-get update && apt-get install -y \
	build-essential \
	git \
	perl \
	make \
	libc6-dev \
	sudo \
	bash \
	curl \
	&& rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN adduser --disabled-password --gecos "" debian && usermod -a -G dialout debian
RUN usermod -a -G sudo debian
RUN perl -pi.orig -e 's/(\%sudo\s+ALL\s*=\s*)\(ALL:ALL\)\s+ALL/$1\(ALL\) NOPASSWD: ALL/' /etc/sudoers

# Build and install mbtget
RUN git clone https://github.com/sourceperl/mbtget.git /tmp/mbtget && \
	cd /tmp/mbtget && \
	perl Makefile.PL && make && make install && \
	cd / && rm -rf /tmp/mbtget

# Copy the exporter script
COPY hvac_exporter.sh /hvac_exporter.sh
RUN chmod +x /hvac_exporter.sh

# Default HVAC IP
ENV HVAC_IP=10.0.1.19

# tmpfs mount for metrics
VOLUME /data

#USER debian
ENTRYPOINT ["/hvac_exporter.sh"]
