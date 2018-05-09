#!/bin/sh

container=`/usr/local/bin/docker run --name ee-mysql --env=MYSQL_ROOT_PASSWORD=mypassword -p 3306:3306 -v /tmp/mysql:/var/lib/mysql  -d mysql/mysql-server:5.6`

until [ "`/usr/local/bin/docker inspect -f {{.State.Running}} $container`" = "true"  ]
do
    /usr/local/bin/docker inspect -f {{.State.Running}} $container
    sleep 0.5;
    echo "checking container status..."
done;

echo "container running"

sourceIp=`/sbin/ip route|awk '/src/ { print $9 }'`

echo $container
echo $sourceIp

result=`/usr/local/bin/docker logs $container | grep -qe "Starting MySQL"`

while [ $? != 0 ]
do
    echo "Waiting on mysql..."
    result=`/usr/local/bin/docker logs $container | grep -qe "Starting MySQL"`
done;

echo "result is: $result"

echo "I think mysql is ready"

destinationIp=`docker inspect -f "{{.NetworkSettings.IPAddress}}" $container`

echo $destinationIp 
sleep 15
docker exec -i $container bash -c "mysql -uroot -pmypassword --execute=\"GRANT ALL ON *.* TO root@'$sourceIp' IDENTIFIED BY 'mypassword';FLUSH PRIVILEGES;\""

echo "##vso[task.setvariable variable=container]$container"
echo "##vso[task.setvariable variable=MySQLIp]$destinationIp"



