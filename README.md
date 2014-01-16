mamp-site-starter
=================
A bash script to create vhost and /etc/hosts config entries for local sites

It's dependent on your using Apache's vhosts setup.

To get vhosts working on MAMP:

1) Open apache config file /Applications/MAMP/conf/apache/httpd.conf

2) In the "Supplemental configuration" section uncomment the following line:
Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

3) Open /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

4) Change:
NameVirtualHost *:80

To:
NameVirtualHost 127.0.0.1:80

5) When you setup your virtualhost directives use the following VirtualHost config as a model
<VirtualHost 127.0.0.1:80>
    ServerName sitename.dev
    DocumentRoot "/changeme/site/document/root"
    <Directory "/changeme/site/document/root">
        AllowOverride All
    </Directory>
</VirtualHost>