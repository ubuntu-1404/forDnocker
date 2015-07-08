name=testers
hname=$(hostname)
logpath=/home/ubuntu/logs
conf1=172.17.0.11:20000
conf2=172.17.0.21:20000
conf3=172.17.0.31:20000
datapath=/home/ubuntu/datafile
mongpath=/root/mongodb-linux-x86_64-ubuntu1404-3.0.3
export LC_ALL=C
tar -zxvf /home/ubuntu/mongodb-linux-x86_64-ubuntu1404-3.0.3.tgz -C /root
if [ ! -d ${logpath} ]; then
        mkdir ${logpath}
fi
if [ ! -d ${datapath} ]; then
        mkdir ${datapath}
fi
if [ "${hname}" = "mongodbrouter.wodezoon.com" ]; then
        ${mongpath}/bin/mongos -fork -logpath ${logpath}/root.log -configdb ${conf1},${conf2},${conf3} -port 27017
fi
if [ "${hname}" = "mongodbconfiger.wodezoon.com" ]; then
        ${mongpath}/bin/mongod -fork -configsvr -dbpath ${datapath} -logpath ${logpath}/conf.log -port 20000
fi
if [ "${hname}" = "mongodbsharer.wodezoon.com" ]; then
        ${mongpath}/bin/mongod -fork -dbpath ${datapath} -logpath ${logpath}/data.log -replSet ${name}
fi
#init.js==>
#rs.reconfig({_id : "testers1",members:[{_id : 0, host : "172.17.0.29:27017",priority:2},{_id : 1, host : "172.17.0.30:27017",priority:1},{_id : 2, host : "172.17.0.31:27017", arbiterOnly:true}]})
#init.js==>

#config router
#sh.addShard("testers/172.17.0.14:27017")
