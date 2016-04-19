#!/bin/bash
######################TIPS###############################
#setup_docker                                           #
#wget -qO- https://get.docker.com/ | sh                 #
#                                                       #
#import export.tar                                      #
#cat /home/export.tar | docker import - targit:latest   #
#                                                       #
#setup_pipework                                         #
#git clone https://github.com/jpetazzo/pipework         #
#########################################################

##############Parameters to be set up####################
index=19
delta=$[index+100]
containerID=mysql:new3
#containerID=8dadf260c3b3
sharedpath=/data/share${index}
containerName=mydocker${index}.wodezoon.com
hostIP=192.168.102.5
containerIP=192.168.102.${delta}
gatewayIP=192.168.102.1
pipath=/home/sam/pipework
desbr=eth0
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
-e INIT=/home/ubuntu/test.sh \
-v ${sharedpath}:/home/ubuntu \
${containerID} /usr/sbin/sshd -D
fi
if [ ${nettype} -eq 2 ]; then
docker run -itd --name ${containerName} --net=none \
-h ${containerName} \
-v ${sharedpath}:/home/ubuntu \
${containerID} /usr/sbin/sshd -D
${pipath}/pipework ${desbr} ${containerName} ${containerIP}/24@${gatewayIP}
docker exec -itd ${containerName} /etc/init.d/mysql restart
fi
if [ ${nettype} -eq 3 ]; then
apt-get install bridge-utils
ip addr del ${hostIP}/24 dev ${oldbr}; \
ip addr add ${hostIP}/24 dev ${desbr}; \
brctl addif ${desbr} ${oldbr}; \
route del default; \
route add default gw ${gatewayIP} dev ${desbr}
fi
###############Some pattern for [docker run]#############
#${containerID} /bin/bash                               #
#                                                       #
#docker for port/memory/volume share                    #
#-m 2000m \                                             #
#########################################################
