#!bin/bash

python installer.py --site-name $FRAPPE_SITE_NAME --admin-password $FRAPPE_ADMIN_PASSWORD --verbose

if [ $? -eq 0 ]; then
    cd frappe-bench
    bench use $FRAPPE_SITE_NAME

    if [ "$FRAPPE_PRODUCTION_MODE" = 1 ]; then
        echo 'Initializing for production ...'

        sudo apt-get update
        sudo apt-get install -y supervisor nginx

        bench setup supervisor <<< "y"
        sudo ln -s `pwd`/config/supervisor.conf /etc/supervisor/conf.d/frappe-bench.conf
        sudo service supervisor start
        sudo supervisorctl reread
        sudo supervisorctl update

        sudo ln -s `pwd`/config/nginx.conf /etc/nginx/conf.d/frappe-bench.conf
        bench set-nginx-port $FRAPPE_SITE_NAME $FRAPPE_PRODUCTION_SITE_PORT <<< "y"
        sudo nginx

        bench restart

        if [ $? -eq 0 ]; then
            echo "Running on production mode ..."
        else
            echo "Failed to initialize for production."
            exit 1
        fi
    else
        echo "Running on development mode ..."
        bench start
    fi

else
    echo "'installer.py' Failed"
    exit 1
fi
