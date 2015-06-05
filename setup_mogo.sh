#setup mongodb
name=testers
logpath=/home/ubuntu/logs
datapath=/home/ubuntu/datafile
mongpath=/root/mongodb-linux-x86_64-ubuntu1404-3.0.3
conf1=192.168.100.56:20000
conf2=192.168.100.57:20000
conf3=192.168.100.58:20000
#IPAddress=10.0.1.136
echo "please put mongod type [0-setupMongo/1-dataSet/2-confSet/3-routSet/4-Replica/5-Sharding]"
read mongod_type

#echo "dbpath=$(pwd)/mongodbpath/data" >> $(pwd)/master.conf
#echo "logpath=$(pwd)/mongodbpath/log" >> $(pwd)/master.conf
#echo "pdfilebath=$(pwd)/mongodbpath/pdfile" >> $(pwd)/master.conf
#echo "directoryperdb=true" >> $(pwd)/master.conf
#echo "logappend=true" >> $(pwd)/master.conf
#echo "replSet=${name}" >> $(pwd)/master.conf
#echo "bind_ip=${IPAddress}" >> $(pwd)/master.conf
#echo "port=27017" >> $(pwd)/master.conf
#echo "oplogSize=10000" >> $(pwd)/master.conf
#echo "fork=true" >> $(pwd)/master.conf
#echo "noprealloc=true" >> $(pwd)/master.conf
if [ ${mongod_type} -eq 0 ]; then
tar -zxvf $(pwd)/mongodb-linux-x86_64-ubuntu1404-3.0.3.tgz -C /root
fi
if [ ${mongod_type} -eq 1 ]; then
${mongpath}/bin/mongod -fork -dbpath ${datapath} -logpath ${logpath}/data.log -replSet ${name} 
fi
if [ ${mongod_type} -eq 2 ]; then
${mongpath}/bin/mongod -fork -configsvr -dbpath ${datapath} -logpath ${logpath}/conf.log  -port 20000
fi
if [ ${mongod_type} -eq 3 ]; then
${mongpath}/bin/mongos -fork -logpath ${logpath}/root.log -configdb ${conf1},${conf2},${conf3} -port 27017
fi

	#mongodb_connection
	#cfg={ _id:"testers", members:[ {_id:0,host:'10.0.1.146:20117',priority:2}, {_id:1,host:'10.0.1.146:20217',priority:1},{_id:2,host:'10.0.1.146:20317',arbiterOnly:true}] };

	#rs.initiate(cfg)
