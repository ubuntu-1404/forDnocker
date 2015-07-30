#-v===the volume which to be shared should exist two files.One is conf ,another is datafile
. /etc/profile

ESAdd=$(pwd)/elasticsearch-1.5.0
dataAdd=/home/ubuntu

ifconfig eth0 | grep "inet addr" > /root/ifconfig
localip=(`tr -sc '[0-9.]' ' ' < /root/ifconfig`)
SerIP=${localip[0]}

#notused
SelIP=10.0.1.111

bindname=elasticsearch_deployed
ES_HEAP_SIZE=4096

#free them on the first time
#mkdir ${dataAdd}/conf
#mkdir ${dataAdd}/datafile

echo "please put your /"ES/" name:"
read tmp
echo "node.name: \"${tmp}\"" >> ${ESAdd}/config/elasticsearch.yml
echo "node.master: true" >> ${ESAdd}/config/elasticsearch.yml
echo "node.data: true" >>  ${ESAdd}/config/elasticsearch.yml
echo "http.max_content_length: 100mb" >>  ${ESAdd}/config/elasticsearch.yml
echo "gateway.expected_nodes: 5" >>  ${ESAdd}/config/elasticsearch.yml
echo "index.analysis.analyzer.ik.type : 'ik'" >> ${ESAdd}/config/elasticsearch.yml
#sed -i "/^# network.bind_host/cnetwork.bind_host: ${SelIP}" ${ESAdd}/config/elasticsearch.yml
#sed -i "/^#network.bind_host/cnetwork.bind_host: ${SelIP}" ${ESAdd}/config/elasticsearch.yml
#sed -i "/^# network.publish_host/cnetwork.publish_host: ${SerIP}" ${ESAdd}/config/elasticsearch.yml
#sed -i "/^#network.publish_host/cnetwork.publish_host: ${SerIP}" ${ESAdd}/config/elasticsearch.yml
sed -i "/^# network.host/cnetwork.host: ${SerIP}" ${ESAdd}/config/elasticsearch.yml
sed -i "/^#network.host/cnetwork.host: ${SerIP}" ${ESAdd}/config/elasticsearch.yml
#sed -i "/^# transport.tcp.port/ctransport.tcp.port: 9300" ${ESAdd}/config/elasticsearch.yml
#sed -i "/^#transport.tcp.port/ctransport.tcp.port: 9300" ${ESAdd}/config/elasticsearch.yml
#sed -i "/^# http.port/chttp.port: 9200" ${ESAdd}/config/elasticsearch.yml
#sed -i "/^#http.port/chttp.port: 9200" ${ESAdd}/config/elasticsearch.yml
sed -i "/^# path.conf:/cpath.conf: ${dataAdd}/conf" ${ESAdd}/config/elasticsearch.yml
sed -i "/^#path.conf:/cpath.conf: ${dataAdd}/conf" ${ESAdd}/config/elasticsearch.yml
echo "path.data: ${dataAdd}/datafile" >> ${ESAdd}/config/elasticsearch.yml
sed -i "/^# path.logs:/cpath.logs: ${dataAdd}/conf" ${ESAdd}/config/elasticsearch.yml
sed -i "/^#path.logs:/cpath.logs: ${dataAdd}/conf" ${ESAdd}/config/elasticsearch.yml
sed -i "/^# cluster.name:/ccluster.name: ${bindname}" ${ESAdd}/config/elasticsearch.yml
sed -i "/^#cluster.name:/ccluster.name: ${bindname}" ${ESAdd}/config/elasticsearch.yml

#change value 1g to 2g))20150604
sed -i "/^    ES_MIN_MEM=256/c    ES_MIN_MEM=2g" ${ESAdd}/bin/elasticsearch.in.sh
sed -i "/^    ES_MAX_MEM=1/c    ES_MAX_MEM=4g" ${ESAdd}/bin/elasticsearch.in.sh

cp -R service/ ${ESAdd}/bin/service/
sed -i "/^set.default.ES_HEAP_SIZE/cset.default.ES_HEAP_SIZE=${ES_HEAP_SIZE}" ${ESAdd}/bin/service/elasticsearch.conf
sed -i "/^set.default.JAVA_HOME/cset.default.JAVA_HOME=${JAVA_HOME}" ${ESAdd}/bin/service/elasticsearch.conf

cp -R plugins/ ${ESAdd}/plugins/

chmod 777 ${ESAdd}
chmod 777 ${ESAdd}/bin/
chmod 777 ${dataAdd}/conf/
chmod 777 ${dataAdd}/datafile/
chmod 777 ${ESAdd}/lib/
chmod 777 ${ESAdd}/plugins/
chmod 777 ${ESAdd}/bin/service/
chmod 777 ${ESAdd}/plugins/analysis-ik/

chmod u+x ${ESAdd}/bin/service/elasticsearch
chmod u+x ${ESAdd}/bin/service/elasticsearch32
chmod u+x ${ESAdd}/bin/service/elasticsearch64

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
${ESAdd}/bin/service/elasticsearch64 start
