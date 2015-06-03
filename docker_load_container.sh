#setup_docker
#wget -qO- https://get.docker.com/ | sh

containerID=hadoop-namenode
#containerID=724e1562a9af
containerName=test1
containerHostName=namenode

docker run -itd --name ${containerName} \
-p 10.0.101.115:20022:22 \
-p 10.0.101.115:20000:50070 \
-p 10.0.101.115:20001:8088 \
-p 10.0.101.115:20002:19888 \
-h ${containerHostName} \
${containerID} /usr/sbin/sshd -D
#${containerID} /bin/bash

#docker for port/memory/volume share
#-m 2000m \
#-v /home/ubuntu:/home/ubuntu \
#-h hostname \
