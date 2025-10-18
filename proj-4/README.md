# Forward and reverse Proxy setup using AWS

In this project we will be trying forward proxy as well as reverse proxy setup

A forward proxy sits between clients (like browsers or applications) and external servers.
Clients send all requests to the proxy, which then makes requests to the internet on their behalf.
This is useful for:

- Controlling outbound internet access

- Caching responses

- Adding authentication or logging

- Masking internal network details

## Forward proxy setup using nginx

We can use below steps to install nginx for forward proxy setup

1) we need to installing the nginx

       sudo apt update
       sudo apt install nginx -y
2) now we need to either Edit the NGINX config file /etc/nginx/nginx.conf or create a separate /etc/nginx/conf.d/forward-proxy.conf.
  **it is recomended to add forward-proxy.conf since any changes to the core config might break the while system.**

         if ($http_host ~* "facebook.com|youtube.com") {
            return 403 "Access to this site is blocked\n";
        }

        # this is used to block the specific domain 
3) we can now restart the nginx and expose the proxy.

       sudo nginx -t
       sudo systemctl reload nginx

        # Exposing the proxy variable
        export http_proxy=http://127.0.0.1:8888
        export https_proxy=http://127.0.0.1:8888
4) now we can try the allowed and blocked site.

       curl -I http://google.com   # allowed site

       curl -I http://facebook.com   # blocked site

if we find the below error in blocked site then the forward proxy setup is working fine

        HTTP/1.1 403 Forbidden
        Access to this site is blocked
