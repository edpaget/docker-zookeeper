# DOCKER-VERSION 0.9.0
# VERSION 0.1

FROM ubuntu:12.04
MAINTAINER Edward paget <ed@zooniverse.org>
 
RUN apt-get update 
RUN apt-get install -y -q openjdk-7-jre-headless wget supervisor

ADD http://mirrors.advancedhosters.com/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz  /opt/
RUN tar xf /opt/zookeeper-3.4.6.tar.gz -C /opt
RUN rm /opt/zookeeper-3.4.6.tar.gz

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD zoo.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
ADD start_zk.sh /opt/start_zk.sh

RUN chmod u+x /opt/start_zk.sh

EXPOSE 2181 2888 3888

ENTRYPOINT ["./opt/start_zk.sh"]
