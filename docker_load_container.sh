#containerID=ubt1404
containerID=724e1562a9af

#docker for port/memory/volume share

#rm -rf $(pwd)/datafile
#mkdir $(pwd)/datafile

docker run -i -t -d \
-p 10.0.1.111:20005:20000 \
-p 10.0.1.111:20517:27017 \
-p 10.0.1.111:20522:22 \
-v /home/ubuntu:/home/ubuntu \
${containerID} /usr/sbin/sshd -D
#${containerID} /bin/bash
#-m 2000m \
#-v /home/ubuntu:/home/ubuntu \
