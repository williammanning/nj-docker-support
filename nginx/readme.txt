Setting up Nginx with Docker and SSL

Prerequisite:
Ensure that whatever application you are trying to use nginx to proxy is running correctly first.
Note the port for the application you are running (example port 3002)
Create a DNS entry for wherever.nooji.io

SSH into the server or docker instance:
sudo apt-get update
sudo apt-get install nginx
sudo service nginx status
git clone https://github.com/gitnooji/certs.git
chmod +X /home/ubuntu/certs/nooji.io/nooji.io.chained.crt
sudo mv  /etc/nginx/sites-available/default  /etc/nginx/sites-available/default.old
sudo vi /etc/nginx/sites-available/default
Enter the following information, substitute the application port in the server section:

server {
       listen         80;
       server_name    nooji.io;
       return         301 https://$server_name$request_uri;
}



server {
        listen 443 ssl;
        ssl on;

        ssl_certificate    /home/ubuntu/certs/nooji.io/nooji.io.chained.crt;
        ssl_certificate_key    /home/ubuntu/certs/nooji.io.key;
        underscores_in_headers on;

        server_name nooji.io;
        access_log /var/log/nginx/nginx.vhost.access.log;
        error_log /var/log/nginx/nginx.vhost.error.log;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass    http://127.0.0.1:3001/;
    }
}

sudo service nginx configtest (if everything is ok, then go to the next step. If review the errors and fix)
sudo service nginx restart
Go to your DNS with https (example: https://dev-pres.nooji.io)
Test to see if your DNS entry forwards from http to https


**************************************************************************************************
Multiple domains with Docker and Nginx
**************************************************************************************************

When you work with Docker and Nginx, you need to create an instance of config for each domain and the file should reflect that:

First remove the old default config:
sudo mv  /etc/nginx/sites-available/default  /etc/nginx/sites-available/default.old


example for API, it is important to specify the subdomain in the server_name

sudo vi /etc/nginx/sites-available/api.nooji.io

    server {
           listen         80;
           server_name    api.nooji.io;
           return         301 https://$server_name$request_uri;
    }

    server {
            listen 443 ssl;
            ssl on;

            ssl_certificate    /home/ubuntu/certs/nooji.io/nooji.io.chained.crt;
            ssl_certificate_key    /home/ubuntu/certs/nooji.io.key;
            underscores_in_headers on;

            server_name api.nooji.io;
            access_log /var/log/nginx/nginx.vhost.access.log;
            error_log /var/log/nginx/nginx.vhost.error.log;

        location / {
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_set_header X-NginX-Proxy true;
            proxy_pass    http://127.0.0.1:3000/;
        }
    }



ls -la  /etc/nginx/sites-available/
-rw-r--r-- 1 root root  789 Jan 16 19:04 api.nooji.io
-rw-r--r-- 1 root root 2074 Apr 26  2016 default.old
-rw-r--r-- 1 root root  781 Jan 13 23:17 default.test
-rw-r--r-- 1 root root  791 Jan 17 00:12 pres.nooji.io
-rw-r--r-- 1 root root  799 Jan 16 19:06 prod-one.nooji.io
-rw-r--r-- 1 root root  793 Jan 17 00:58 viber.nooji.io

Also in the sites-enabled, this is through symbolic link:
    sudo ln -s /etc/nginx/sites-available/api.nooji.io /etc/nginx/sites-enabled/
    sudo ln -s /etc/nginx/sites-available/pres.nooji.io /etc/nginx/sites-enabled/
    sudo ln -s /etc/nginx/sites-available/viber.nooji.io /etc/nginx/sites-enabled/
    sudo ln -s /etc/nginx/sites-available/prod-one.nooji.io /etc/nginx/sites-enabled/

ls -la  /etc/nginx/sites-enabled/

lrwxrwxrwx 1 root root   39 Jan 16 19:10 api.nooji.io -> /etc/nginx/sites-available/api.nooji.io
lrwxrwxrwx 1 root root   40 Jan 16 19:10 pres.nooji.io -> /etc/nginx/sites-available/pres.nooji.io
lrwxrwxrwx 1 root root   44 Jan 16 19:11 prod-one.nooji.io -> /etc/nginx/sites-available/prod-one.nooji.io
lrwxrwxrwx 1 root root   41 Jan 16 19:11 viber.nooji.io -> /etc/nginx/sites-available/viber.nooji.io
