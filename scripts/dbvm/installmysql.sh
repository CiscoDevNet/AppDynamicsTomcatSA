#!/bin/bash
echo $1
sudo apt update
apt-get install debconf
export DEBIAN_FRONTEND=noninteractive 
debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password password '$1''
debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password_again password '$1''
# debconf-set-selections <<< "mysql-server mysql-server/root_password password '$1'"
# sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password '$1'"
sudo apt-get -y install mysql-server
sed 's/dbvmip/'$5'/g' /tmp/mysqld.cnf > /tmp/output.file
sudo cp /tmp/output.file /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql.service


database=$2
user=$3
pass=$4
ip=$5

echo "database is $2"
echo "user is $3"
mysql -uroot -proot <<MYSQL_SCRIPT
CREATE DATABASE ${database};
CREATE USER '${user}@localhost' IDENTIFIED BY '${pass}';
GRANT ALL PRIVILEGES ON ${database}.* TO '${user}'@'localhost' IDENTIFIED BY '${pass}';
CREATE USER '${user}@${ip}' IDENTIFIED BY '${pass}';
GRANT ALL PRIVILEGES ON ${database}.* TO '${user}'@'${ip}' IDENTIFIED BY '${pass}';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

