server {
        listen 80;

        root /var/www/clarkeplumo.com/public;
        index index.php index.html index.htm;

        server_name clarkeplumo.com;

        location ~* \.(?:ico|css|js|gif|jpe?g|png)$ {
                expires 30d;
                add_header Pragma public;
                add_header Cache-Control "public";
        }

        location / {
                try_files $uri $uri/ /index.php$is_args$args;
        }

        location ~ \.php$ {
                try_files $uri /index.php =404;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
                add_header Cache-Control "no-transform";
        }

}
