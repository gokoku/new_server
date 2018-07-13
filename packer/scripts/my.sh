echo ">>> php5.7 install"
yum -y install epel-release
yum -y install unzip
yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum -y install --enablerepo=remi,remi-php71 php php-devel php-mbstring php-intl php-mysql php-xml php-pear php-pdo php-gd php-mcypt php-common


echo ">>> apache install"
yum -y install httpd httpd-devel
systemctl enable httpd
systemctl start httpd

echo ">>> mysql install"
yum -y remove mariadb-libs
rm -rf /var/lib/mysql

yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum -y install mysql mysql-server mysql-devel

# 既存ユーザのパスワードが使えるようにする
echo "validate-password=OFF" >> /etc/my.cnf

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
