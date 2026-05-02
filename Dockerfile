FROM centos:7

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y epel-release && \
    yum install -y unzip readline-devel readline which gcc make mysql && \
    yum clean all

COPY lua-5.1.5.tar.gz /tmp/
COPY luarocks-3.0.4.tar.gz /tmp/

RUN cd /tmp && tar -zxvf lua-5.1.5.tar.gz && \
    cd lua-5.1.5 && make linux test && make install && \
    cd /tmp && tar -zxvf luarocks-3.0.4.tar.gz && \
    cd luarocks-3.0.4 && \
    ./configure --with-lua=/usr/local --with-lua-include=/usr/local/include && \
    make && make install && make bootstrap && \
    luarocks install luasocket && \
    rm -rf /tmp/*

RUN mkdir -p /home/server

COPY xyh5/home/server /home/server

RUN chmod -R 777 /home/server

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home/server

EXPOSE 10001 11001 12001 8001 8004

CMD ["/entrypoint.sh"]
