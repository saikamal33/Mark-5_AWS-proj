# Reverse proxy setup

## application setup in server

### Python application server setup in the background

- we need to first install the python

			sudo apt update
   			mkdir backend
   			sudo apt install -y python3-pip python3-venv

- create the virtual env for python

			pyhton3 -m venv venv
			source venv/bin/activate

- inside the env we are installing flask the gunicorn

			pip install flask gunicorn
   	
- provide the application source code in app.py.

- we will be running the app as a backend service by setting it in systemd.

			CURRENT_DIR=$(pwd)  # to set the current dir value in service

		  cat <<EOT | sudo tee /etc/systemd/system/backend.service
		  [Unit]
		  Description=Backend Service
		  After=network.target

		  [Service]
		  User=ubuntu
		  WorkingDirectory=$CURRENT_DIR
		  Environment="PATH=$CURRENT_DIR/venv/bin"
		  ExecStart=$CURRENT_DIR/venv/bin/gunicorn --bind 0.0.0.0:5000 app:app
		  Restart=always

		  [Install]
		  WantedBy=multi-user.target
		  EOT
- Now we will reload the deamon and start the services

	  		sudo systemctl daemon-reload
   			sudo systemctl enable backend
   			sudo systemctl start backend
   
### Nginx reverse proxy setup in the proxy server

- Installing of the nginx server

	  sudo apt update
      sudo apt install nginx -y
- we need to configure the nginx as reverse proxy

	  cat <<EOT | sudo tee /etc/nginx/sites-available/reverse-proxy
      server {
  		listen 80;
  		server_name _;

		location / {
  			proxy_pass http://YOUR_BACKEND_IP:5000;     we need to update this with backend server
  			proxy_set_header HOST \$host;
  			proxy_set_header X-Real-IP \$remote_addr;
  			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
  			proxy_set_header X-Forwarded-proto \$scheme;
  		}
      }
      EOT
- we can enable the site, by creating a softlink and removing the default setup

	  sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
  	  sudo rm /etc/nginx/sites-enabled/default
      sudo systemctl restart nginx

Now we can test the server by accessing the nginx server in port 80 and see if we can access it from client side.
