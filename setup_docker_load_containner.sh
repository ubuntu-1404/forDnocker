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
containerID=724e1562a9af				#
containerName=test					#
sharedpath=/home/ubuntu					#
hostIP=192.168.100.113					#
							#
containerIP=192.168.100.99				#
gatewayIP=192.168.100.1					#
pipath=/home/pipework					#
desbr=br0						#
oldbr=eth0						#
#########################################################
echo "please choose container build mode--1:NAT;2:Bridge;3:SetupPipwork;"
read net-type
if [ ${net-type} -eq 1 ]; then
docker run -itd --name ${containerName} \
-p ${hostIP}:20022:22 \
-h ${containerName} \
-v ${sharedpath}:/home/ubuntu \			
${containerID} /usr/sbin/sshd -D
fi
if [ ${net-type} -eq 2 ]; then
docker run -itd --name ${containerName} --net=none \
-h ${containerName} \
-v ${sharedpath}:/home/ubuntu \			
${containerID} /usr/sbin/sshd -D
${pipath}/pipework ${desbr} ${containerName} ${containerIP}/24@${gatewayIP}
fi
if [ ${net-type} -eq 3 ]; then
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