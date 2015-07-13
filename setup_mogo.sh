name=testers1
logpath=/home/ubuntu/logs
datapath=/home/ubuntu/datafile
mongpath=/root/mongodb-linux-x86_64-ubuntu1404-3.0.3
mmspath=/opt/mongodb/mms/conf/conf-mms.properties
export LC_ALL=C
if [ ! -d ${mongpath} ]; then
        tar -zxvf /home/ubuntu/mongodb-linux-x86_64-ubuntu1404-3.0.3.tgz -C /root
fi
if [ ! -d ${logpath}/appdb ]; then
        mkdir -p ${logpath}/appdb
fi
if [ ! -d ${logpath}/backup ]; then
        mkdir -p ${logpath}/backup
fi
if [ ! -d ${datapath}/appdb ]; then
        mkdir -p ${datapath}/appdb
fi
if [ ! -d ${datapath}/bakup ]; then
        mkdir -p ${datapath}/bakup
fi

#init.js==>
for ((i=0;i<3;i++));do
        master=$[i*4+202]
        slaver=$[i*4+203]
        arbter=$[i*4+204]
        echo "cfg={_id : \"testers1\",members:[{_id : 0, host : 'mongodbsharer${master}.wodezoon.com',priority:2},{_id : 1, host : 'mongodbsharer${slaver}.wodezoon.com',priority:1},{_id : 2, host : 'mongodbsharer${arbter}.wodezoon.com', arbiterOnly:true}]}"  > ${mongpath}/rs.initiate${master}.js
        echo "rs.initiate(cfg)" >> ${mongpath}/rs.initiate${master}.js
        echo "sh.addShard(\"testers$i/mongodbsharer${master}.wodezoon.com\")" >   ${mongpath}/sh.addShard$i.js
done
#init.js==>

if [[ $(hostname) = mongodbrouter* ]]; then
        ${mongpath}/bin/mongos -fork -logpath ${logpath}/root.log -configdb mongodbsharer205.wodezoon.com,mongodbsharer209.wodezoon.com,mongodbsharer213.wodezoon.com  -port 27017
        if [[ $(hostname) = mongodbrouter214* ]]; then
                for ((i=1;i<=3;i++)) ; do
                        ${mongpath}/bin/mongo ${mongpath}/sh.addShard$i.js
                done
        fi
fi
if [[ $(hostname) = mongodbconfer* ]]; then
        ${mongpath}/bin/mongod -fork -configsvr -dbpath ${datapath} -logpath ${logpath}/conf.log -port 27017
        echo "$(hostname)" > ${mongpath}/host
        tmp=`tr -sc '[0-9]' ' ' < ${mongpath}/host`
        typeset tmp1=$((tmp-3))
        echo "${mongpath}/bin/mongo mongodbsharer${tmp1}.wodezoon.com --shell ${mongpath}/rs.initiate${tmp1}.js"
        ${mongpath}/bin/mongo mongodbsharer${tmp1}.wodezoon.com --shell ${mongpath}/rs.initiate${tmp1}.js
fi
if [[ $(hostname) = mongodbsharer* ]]; then
        ${mongpath}/bin/mongod -fork -dbpath ${datapath}/appdb -logpath ${logpath}/appdb/data.log -replSet ${name} -port 27017 --oplogSize 1024
#        ${mongpath}/bin/mongod -fork -dbpath ${datapath}/bakup -logpath ${logpath}/bakup/data.log -replSet ${name} -port 27018
#        if [[ $(hostname) = mongodbsharer201* ]]; then
#                if [ ! -f ${mmspath} ]; then
#                        dpkg -i /home/ubuntu/mongodb-mms_1.8.0.276-1_x86_64.deb
#                fi
#                sed -i "/^mms.centralUrl=/cmms.centralUrl=http://${dbhost1}:20180" ${mmspath}
#                sed -i "/^mms.backupCentralUrl=/cmms.backupCentralUrl=http://${dbhost1}:20181" ${mmspath}
#                sed -i "/^mms.fromEmailAddr=/cmms.fromEmailAddr=qibaolai@linkgent.com" ${mmspath}
#                sed -i "/^mms.replyToEmailAddr=/cmms.replyToEmailAddr=qibaolai@linkgent.com" ${mmspath}
#                sed -i "/^mms.adminFromEmailAddr=/cmms.adminFromEmailAddr=qibaolai@linkgent.com" ${mmspath}
#                sed -i "/^mms.adminEmailAddr=/cmms.adminEmailAddr=qibaolai@linkgent.com" ${mmspath}
#                sed -i "/^mms.bounceEmailAddr=/cmms.bounceEmailAddr=qibaolai@linkgent.com" ${mmspath}
#                echo "rs.initiate()" > /home/ubuntu/init.js
#                echo "rs.conf()" >> /home/ubuntu/init.js
#                ${mongpath}/bin/mongo /home/ubuntu/init.js
#                service mongodb-mms start
#        fi
fi
#wget http://${dbhost1}:20180/download/agent/automation/mongodb-mms-automation-agent-manager_2.0.9.1201-1_amd64.deb
#wget http://${dbhost1}:20180/download/agent/monitoring/mongodb-mms-monitoring-agent_3.3.1.193-1_amd64.deb
#dpkg -i mongodb-mms-automation-agent-manager_2.0.9.1201-1_amd64.deb
#dpkg -i mongodb-mms-monitoring-agent_3.3.1.193-1_amd64.deb
#sed -i "/^mmsGroupId=/cmmsGroupId=559e2eade4b0e2f7d7d2a7b3"     /etc/mongodb-mms/automation-agent.config
#sed -i "/^mmsApiKey=/cmmsApiKey=32c8dd715ee4f9d1b8f3233f787f44ff"       /etc/mongodb-mms/automation-agent.config
#sed -i "/^mmsApiKey=/cmmsApiKey=32c8dd715ee4f9d1b8f3233f787f44ff"       /etc/mongodb-mms/monitoring-agent.config
#sed -i "/^mmsBaseUrl=/cmmsBaseUrl=http://${dbhost1}:20180"    /etc/mongodb-mms/automation-agent.config
#sed -i "/^mmsBaseUrl=/cmmsBaseUrl=http://${dbhost1}:20180"    /etc/mongodb-mms/monitoring-agent.config
#/opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent -f /etc/mongodb-mms/automation-agent.config
#/opt/mongodb-mms-automation/bin/mongodb-mms-monitoring-agent -f /etc/mongodb-mms/monitoring-agent.config
