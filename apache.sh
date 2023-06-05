#!/bin/bash
sudo su
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "HELLO WORLD from $(hostname -f)" > /var/www/html/index.html