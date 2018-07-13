#!/bin/bash

password='Root+root=2'
config=$(find /var/www/html -name wp-config.php)

echo ">>> network restart"
systemctl restart network

if [ -e "$config" ];
then
    echo ">>> Word Press の $config がありました"
    db_name=$(grep  -e "DB_NAME" $config | perl -pe 's|^.*[,]\s*'\''(.*)'\''\).*$|$1|sg')
    db_user=$(grep  -e "DB_USER" $config | perl -pe 's|^.*[,]\s*'\''(.*)'\''\).*$|$1|sg')
    db_passwd=$(grep  -e "DB_PASSWORD" $config | perl -pe 's|^.*[,]\s*(.*)\).*$|$1|sg')

    echo ">>> Word Press のデータベースを作ります $db_name"
    MYSQL_PWD=$password mysql -uroot -e "create database $db_name;"

    echo ">>> Word Press のユーザをデータベースに作ります $db_user : $db_passwd"
    MYSQL_PWD=$password mysql -uroot -e "grant all privileges on $db_name.* to $db_user@localhost identified by $db_passwd;"

    dump=$(find /var/www/html -maxdepth 1 -name "*.sql")
    if [ -e "$dump" ];
    then
        echo ">>> SQL ダンプデータを読み込みます $dump"
        MYSQL_PWD=$password mysql $db_name < $dump -uroot
    fi
fi
