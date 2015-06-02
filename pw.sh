#setup_pipework
#git clone https://github.com/jpetazzo/pipework

containerName=test1
containerIP=10.0.101.99
gatewayIP=10.0.101.1
hostIP=10.0.101.115
pipath=/home/pipework
desbr=br0
oldbr=eth0

${pipath}/pipework ${desbr} ${containerName} ${containerIP}/24@${gatewayIP}
ip addr add ${hostIP}/24 dev ${desbr}; \
ip addr del ${hostIP}/24 dev ${oldbr}; \
brctl addif ${desbr} ${oldbr}; \
route del default; \
route add default gw ${gatewayIP} dev ${desbr}
