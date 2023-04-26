FROM       ubuntu:latest
MAINTAINER Ben Olsen "https://registry.sb.upf.edu"
LABEL authors="Ben Olsen"
LABEL version="18.04"
LABEL description="Docker image for running facebook Dinov2 image segmenter"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y openssh-server nmap sudo telnet sssd
RUN apt-get install -y software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa
RUN set -xe \
    && apt-get install -y python3.9 \
    && apt-get install -y python3-pip \
    && pip3 install --upgrade pip

RUN bash -c 'echo HELLOOOO'
RUN bash -c 'echo "$(which python)"'
COPY requirements.txt /dinov2/
COPY dinov2 /dinov2/
COPY scripts /dinov2/
COPY setup.py /dinov2/
COPY hubconf.py /dinov2/

WORKDIR /dinov2
RUN pip3 install -r requirements.txt

RUN mkdir /var/run/sshd
RUN echo 'root:xxxxxxxxxxxx' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
