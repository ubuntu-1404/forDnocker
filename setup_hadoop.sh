#-v===the volume which to be shared should exist two files.One is namenode ,another is datanode
. /etc/profile
HADOOP_HOME=/root/hadoop-2.6.0

node(){
	echo "namenodeService-Press 1;datanodeService-Press 2"
	read status
	case "$status" in
		1)return 0;;
		2)return 1;;
		*);;
	esac
}
#if node() $1 then
#fi

echo "select service to be run--1:format your cluster;2:run up your namenode and resourcemanager service;3:run up your datanode and noderesource service;4:update hosts"
read tmp
if [ ${tmp} -eq 1 ]; then
${HADOOP_HOMEl}/bin/hdfs namenode -format cluster-name
fi
if [ ${tmp} -eq 2 ]; then
${HADOOP_HOME}/sbin/hadoop-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ --script hdfs stop namenode
${HADOOP_HOME}/sbin/hadoop-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ --script hdfs start namenode
${HADOOP_HOME}/sbin/yarn-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ stop resourcemanager
${HADOOP_HOME}/sbin/yarn-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ start resourcemanager
fi
if [ ${tmp} -eq 3 ]; then
${HADOOP_HOME}/sbin/hadoop-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ --script hdfs stop datanode
${HADOOP_HOME}/sbin/hadoop-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ --script hdfs start datanode
${HADOOP_HOME}/sbin/yarn-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ stop nodemanager       
${HADOOP_HOME}/sbin/yarn-daemon.sh --config ${HADOOP_HOME}/etc/hadoop/ start nodemanager
fi
if [ ${tmp} -eq 4 ]; then
echo "192.168.100.91	namenode" >> /etc/hosts
echo "192.168.100.92	datenode1" >> /etc/hosts
echo "192.168.100.93	datanode2" >> /etc/hosts
echo "192.168.100.94	datanode3" >> /etc/hosts
fi
