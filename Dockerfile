FROM lsiobase/ffmpeg:bin as binstage
FROM lsiobase/ubuntu:bionic

# Add files from binstage
COPY --from=binstage / /

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# hardware env
ENV \
 LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri" \
 NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
 NVIDIA_VISIBLE_DEVICES="all"

RUN \
 echo "**** install runtime ****" && \
 apt-get update && \
 apt-get install -y \
	i965-va-driver \
  libasound \
	libexpat1 \
	libgl1-mesa-dri \
	libglib2.0-0 \
	libgomp1 \
	libharfbuzz0b \
	libv4l-0 \
	libx11-6 \
	libxcb1 \
	libxext6 \
	libxml2 && \
 echo "**** clean up ****" && \
 rm -rf \
	/var/lib/apt/lists/* \
	/var/tmp/*

COPY /root /

ENTRYPOINT ["/ffmpegwrapper.sh"]
