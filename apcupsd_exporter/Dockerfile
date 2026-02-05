FROM debian:bookworm

LABEL maintainer="Kristoffer Ek <stoffer@skulp.net>"

# Install dependencies: git, go build tools
RUN apt-get update && apt-get install -y \
	git \
	build-essential \
	golang-go \
	curl \
	bash \
	sudo

# Create non-root user
RUN adduser --disabled-password --gecos "" debian && usermod -a -G sudo debian
RUN perl -pi.orig -e 's/(\%sudo\s+ALL\s*=\s*)\(ALL:ALL\)\s+ALL/$1\(ALL\) NOPASSWD: ALL/' /etc/sudoers

# Clone and build apcupsd_exporter
RUN git clone https://github.com/mdlayher/apcupsd_exporter.git /tmp/apcupsd_exporter && \
	cd /tmp/apcupsd_exporter && \
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /apcupsd_exporter ./cmd/apcupsd_exporter && \
	chmod +x /apcupsd_exporter && \
	rm -rf /tmp/apcupsd_exporter

# Default UPS host and port
ENV APC_ADDRESS=127.0.0.1:3551
ENV TELEMETRY_ADDR=:9102
#ENV APC_UNIX_SOCKET=/var/run/apcupsd.ttyS0

EXPOSE 9162

USER debian
ENTRYPOINT ["sh", "-c", "exec /apcupsd_exporter -apcupsd.addr ${APC_ADDRESS}"]
