FROM      debian
MAINTAINER Evan Gaustad
# Based on version from David Pisano

# Specify container username e.g. training, demo
ENV VIRTUSER bro
# Specify program
ENV PROG bro
# Specify source extension
ENV EXT tar.gz
# Specify Bro version to download and install (e.g. bro-2.3.1, bro-2.4)
ENV VERS 2.5
# Install directory
ENV PREFIX /opt/bro
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin

RUN groupadd -r $VIRTUSER && \
    useradd -r -g $VIRTUSER $VIRTUSER && \
    mkdir /home/bro; chown -R bro:bro /home/bro

WORKDIR /home/$VIRTUSER
COPY pcaps_to_logs.sh /home/$VIRTUSER

RUN apt-get update -qq && \
    apt-get install -yq build-essential cmake make gcc g++ flex bison libpcap-dev libgeoip-dev libssl-dev python-dev zlib1g-dev libmagic-dev swig2.0 ca-certificates supervisor wget --no-install-recommends && \
    wget --no-check-certificate https://www.bro.org/downloads/$PROG-$VERS.$EXT && \
    tar -xzf $PROG-$VERS.$EXT && \
    rm -rf /home/$VIRTUSER/$PROG-$VERS.$EXT && \
    cd /home/$VIRTUSER/$PROG-$VERS && \
    ./configure --prefix=$PREFIX && \
    make && \
    make install && \
    cd /home/$VIRTUSER && \
    rm -rf /home/$VIRTUSER/$PROG-$VERS && \
    chmod u+s $PREFIX/bin/$PROG ; \
    chmod u+s $PREFIX/bin/broctl ; \
    chmod u+s $PREFIX/bin/capstats ;\
    apt-get purge -y build-essential cmake make gcc g++ flex bison zlib1g-dev python-dev zlib1g-dev libmagic-dev swig2.0 && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY local.bro /opt/bro/share/site/local.bro

#RUN echo '@load policy/tuning/json-logs.bro' >> /opt/bro/share/bro/site/local.bro

