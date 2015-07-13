######################TIPS###############################
#setup_docker						#
#wget -qO- https://get.docker.com/ | sh			#
#							#
#import export.tar					#
#cat /home/export.tar | docker import - targit:latest	#
#							#
#setup_pipework						#
#git clone https://github.com/jpetazzo/pipework		#
#########################################################

##############Parameters to be set up####################
index=216
#containerID=724e1562a9af
containerID=b4c88ba3e6f7
sharedpath=/data/share${index}
containerName=mongodbrouter${index}.wodezoon.com
hostIp=192.168.102.249
containerIP=192.168.100.33
gatewayIP=192.168.100.1
pipath=/home/sam/pipework
desbr=br0
oldbr=eth0
#########################################################
echo "please choose container build mode--1:NAT;2:Bridge;3:SetupPipwork;"
read nettype
if [ ${nettype} -eq 1 ]; then
docker run -itd --name ${containerName} \
-p ${hostIP}:${index}22:22 \
-p ${hostIP}:${index}17:27017 \
-p ${hostIP}:${index}18:27018 \
-p ${hostIP}:${index}80:8080 \
-p ${hostIP}:${index}81:8081 \
-h ${containerName} \
-v ${sharedpath}:/home/ubuntu \
${containerID} /usr/sbin/sshd -D
fi
if [ ${nettype} -eq 2 ]; then
docker run -itd --name ${containerName} --net=none \
-h ${containerName} \
-v ${sharedpath}:/home/ubuntu \
${containerID} /usr/sbin/sshd -D
${pipath}/pipework ${desbr} ${containerName} ${containerIP}/24@${gatewayIP}
fi
if [ ${nettype} -eq 3 ]; then
apt-get install bridge-utils
ip addr add ${hostIP}/24 dev ${desbr}; \
ip addr del ${hostIP}/24 dev ${oldbr}; \
brctl addif ${desbr} ${oldbr}; \
route del default; \
route add default gw ${gatewayIP} dev ${desbr}
fi
###############Some pattern for [docker run]#############
#${containerID} /bin/bash				#
#							#
#docker for port/memory/volume share			#
#-m 2000m \						#
#########################################################
