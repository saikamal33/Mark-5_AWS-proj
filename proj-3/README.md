# Mark-7
## This is to Launch a website with apache service inside an AWS EC2 instance so we can access it externally.

![Apache website](https://github.com/saikamal33/Mark-5_AWS-proj/blob/main/proj-3/images/Screenshot%202025-07-23%20152558.png)
we can install httpd in ubuntu
~~~
sudo apt install apache2
~~~

The source code need to be present in "/var/www/html", to access it in website

we need to start the httpd (apache2) service before accessing it 
~~~
sudo service apache2 start
~~~
