echo ">>> php5.7 install"
yum -y install epel-release
yum -y install unzip
yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum -y install --enablerepo=remi,remi-php71 php php-devel php-mbstring php-intl php-mysql php-xml php-pear php-pdo php-gd php-mcypt php-common
# timezone setting
sed -i -e "s/^;date.timezone.*$/date.timezone = 'Asia\/Tokyo'/g" /etc/php.ini


echo ">>> apache install"
yum -y install httpd httpd-devel
systemctl enable httpd
systemctl start httpd

echo ">>> mysql install"
yum -y install wget
yum -y remove mariadb*
rm -fr /var/lib/mysql/*.*
rm -fr /var/lib/mysql

wget -O /tmp/mysql57 http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
rpm -Uvh /tmp/mysql57
yum -y install mysql mysql-community-server mysql-devel

echo "explicit_defaults_for_timestamp=1" >> /etc/my.cnf

systemctl enable mysqld
systemctl start mysqld
password=`cat /var/log/mysqld.log | grep "A temporary password" | tr ' ' '\n' | tail -n1`
mysql -uroot -p${password} --connect-expired-password <<EOF
SET password FOR root@localhost=password('Root+root=2');
EOF

echo ">>> emacs install"
yum -y install ncurses-devel
yum -y install emacs-nox

echo ">>> network restart"
systemctl restart network


echo "<?php phpinfo(); ?>" >/var/www/html/info.php
