#!/bin/bash

source ./common-1.sh

check_root

echo "Please enter DB password:"
read mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
systemctl enable mysqld &>>$LOGFILE
systemctl start mysqld &>>$LOGFILE

#Below code will be useful for idempotent secure
mysql -h db.neelareddy.store -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
else
    echo -e "MYSQL Root password setup...$Y SKIPPING $N"
fi    
