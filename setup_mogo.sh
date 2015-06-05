#setup mongodb
name=testers
#IPAddress=10.0.1.136
rm -rf /usr/mongodb-linux-x86_64-ubuntu1404-3.0.3
tar -zxvf $(pwd)/mongodb-linux-x86_64-ubuntu1404-3.0.3.tgz -C /usr
mongpath=/usr/mongodb-linux-x86_64-ubuntu1404-3.0.3
echo "please put mongod type [1-dataSet/2-confSet/3-routSet/4-Replica/5-Sharding]"
read mongod_type
rm -rf /usr/mongodbpath/log
mkdir -p /usr/mongodbpath/log

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

if [ ${mongod_type} -eq 1 ]; then
rm -rf /usr/mongodbpath/data-share
mkdir -p /usr/mongodbpath/data-share
${mongpath}/bin/mongod -fork -dbpath /usr/mongodbpath/data-share -logpath /usr/mongodbpath/log/data.log -replSet ${name} 
fi

if [ ${mongod_type} -eq 2 ]; then
rm -rf /usr/mongodbpath/data-confi
mkdir -p /usr/mongodbpath/data-confi
${mongpath}/bin/mongod -fork -configsvr -dbpath /usr/mongodbpath/data-confi -logpath /usr/mongodbpath/log/conf.log  -port 20000
fi

if [ ${mongod_type} -eq 3 ]; then
${mongpath}/bin/mongos -fork -logpath /usr/mongodbpath/log/root.log -configdb 10.0.1.111:20001,10.0.1.111:20002,10.0.1.111:20003 -port 27017
fi

	#mongodb_connection
	#cfg={ _id:"testers", members:[ {_id:0,host:'10.0.1.146:20117',priority:2}, {_id:1,host:'10.0.1.146:20217',priority:1},{_id:2,host:'10.0.1.146:20317',arbiterOnly:true}] };

	#rs.initiate(cfg)
