# DOCKER-VERSION 0.9.0
# VERSION 0.1

FROM ubuntu:12.04
MAINTAINER Edward paget <ed@zooniverse.org>
 
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update 
RUN apt-get upgrade -y

RUN apt-get install -y -q openjdk-7-jre-headless wget
RUN wget -q -O /opt/zookeeper-3.4.6.tar.gz http://mirrors.ibiblio.org/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
RUN tar -xvf /opt/zookeeper-3.4.6.tar.gz -C /opt
RUN rm /opt/zookeeper-3.4.6.tar.gz
ADD zoo.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
ADD start_zk.sh /opt/start_zk.sh
RUN chmod u+x /opt/start_zk.sh

EXPOSE 2181 2888 3888

ENTRYPOINT ["./opt/start_zk.sh"]
