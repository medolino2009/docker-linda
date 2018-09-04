FROM babim/ubuntubase

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home

RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor \
        pwgen sudo vim-tiny x11vnc x11vnc-data \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        fonts-wqy-microhei \
        nginx \
        wget \
        libqt5widgets5 \
        iputils-ping \
        python-pip python-dev build-essential python-setuptools \
        mesa-utils libgl1-mesa-dri \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

#ADD web /web/
#RUN pip install -r /web/requirements.txt
### Install Linda wallet
RUN mkdir -p /home/ubuntu/Linda \
ENV LINDA_VERSION v3.0.0.0g
ADD https://github.com/TheLindaProjectInc/Linda/releases/download/v3.0.0.0/Unix.Linda-qt-v3.0.0.0g.tar.gz /home/ubuntu/Linda
ADD https://github.com/TheLindaProjectInc/Linda/releases/download/v3.0.0.0/Unix.Lindad-v3.0.0.0g.tar.gz /home/ubuntu/Linda
RUN tar xzf /home/ubuntu/Linda/Unix.Linda-qt-v3.0.0.0g.tar.gz -C /home/ubuntu/Linda
RUN tar xzf /home/ubuntu/Linda/Unix.Lindad-v3.0.0.0g.tar.gz -C /home/ubuntu/Linda
RUN mkdir /home/ubuntu/.Linda
RUN mkdir /home/ubuntu/linda-wallpapers
RUN chmod -R 777 /home/ubuntu/Linda/Linda-qt
RUN chmod -R 777 /home/ubuntu/Linda/Lindad
RUN chmod -R 777 /home/ubuntu/.Linda
RUN rm /home/ubuntu/Linda/Unix.Linda-qt-v3.0.0.0g.tar.gz
RUN rm /home/ubuntu/Linda/Unix.Lindad-v3.0.0.0g.tar.gz
RUN mkdir -p /home/ubuntu/.config/pcmanfm/LXDE/

# tini for subreap                                   
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD linda-wallpapers /home/ubuntu/linda-wallpapers/
ADD linda-wallpapers/desktop-items-0.conf /home/ubuntu/.config/pcmanfm/LXDE/
COPY linda-wallpapers/panel /home/ubuntu/.config/lxpanel/LXDE/panels/
EXPOSE 6080 33820
WORKDIR /home
ENTRYPOINT ["/startup.sh"]
