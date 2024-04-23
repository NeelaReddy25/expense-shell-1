#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MYSQL"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MYSQL"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIADTE $? "Setting up root password"

#Below code will be useful for idempotent secure
mysql -h db.neelareddy.store -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
else
    echo "MYSQL Root password setup...$Y SKIPPING $N"
    VALIDATE $? "MYSQL Root password setup"
fi    
