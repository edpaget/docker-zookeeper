#!/bin/bash
set -e

usage() {
  echo -e "
  usage: $0 options

  Configures and starts Zookeeper inside a docker container.

  OPTIONS:
    -h Show this message
    -c list of zookeepers in this cluster, seperated by commas
    -i Zookeeper id
    "
}

ZKS=
ZK_ID=
ZK_VERSION=3.4.6

while getopts "hc:i:" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    c)
      CLUSTER=$OPTARG
      ;;
    i)
      ZK_ID=$OPTARG
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [[ -z $CLUSTER ]] || [[ -z $ZK_ID ]];
then
  usage
  exit 1
fi

mkdir -p /opt/zookeeper/data /opt/zookeeper/log
echo -e "$ZK_ID" > /opt/zookeeper/data/myid

IFS=',' read -ra ZK <<< "$CLUSTER"
for i in "${!ZK[@]}"; do
  echo -e "server.$i=${ZK[$i]}:2888:3888" >> "/opt/zookeeper-$ZK_VERSION/conf/zoo.cfg"
done

cat << EOF >> /etc/supervisor/conf.d/supervisord.conf
[program:zookeeper]
command=/opt/zookeeper-$ZK_VERSION/bin/zkServer.sh start-foreground
EOF

/usr/bin/supervisord
