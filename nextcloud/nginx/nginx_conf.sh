#!/bin/bash

if [[ -f /etc/nginx/sites-enabled/default ]]; then
  rm /etc/nginx/sites-enabled/default
fi

if $IPV4; then

cat > /etc/nginx/conf.d/reverse-proxy.conf <<EOF
map \$http_upgrade \$connection_upgrade {
    default Upgrade;
    '' close;
}

server {
    location / {
        proxy_pass http://localhost:11000;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Port \$server_port;
        proxy_set_header X-Forwarded-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Host \$host;
    
        client_body_buffer_size 512k;
        client_max_body_size 0;

        # Websocket
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
    }

    location /aio/ {
        proxy_pass http://localhost:8000/;
        proxy_redirect / /aio/;
        proxy_set_header Host \$host;
        sub_filter 'href="/' 'href="/aio/';
        sub_filter 'src="/' 'src="/aio/';
        sub_filter 'action="' 'action="/aio';
        sub_filter "url('" "url('/aio";
        sub_filter 'value="" placeholder="nextcloud.yourdomain.com"' 'value="$NEXTCLOUD_DOMAIN"';
        sub_filter '"Submit domain"' '"Submit domain" id="domain-submit"';
                sub_filter '<body>' "<body onload=\"if(document.getElementById('domain-submit')) {document.getElementById('domain-submit').click()}\">";
        sub_filter_once off;
        sub_filter_types text/css;
    }

    location = /api/auth/getlogin {
        return 301 /aio/api/auth/getlogin\$is_args$args;
    }
    proxy_connect_timeout       7d;
    proxy_send_timeout          7d;
    proxy_read_timeout          7d;
    send_timeout                7d;
}
EOF

else

cat > /etc/nginx/conf.d/reverse-proxy.conf <<EOF
map \$http_upgrade \$connection_upgrade {
    default Upgrade;
    '' close;
}

server {
    location / {
        proxy_pass http://localhost:11000;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Port \$server_port;
        proxy_set_header X-Forwarded-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Host \$host;
    
        client_body_buffer_size 512k;
        client_max_body_size 0;

        # Websocket
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
    }

    location /aio/ {
        proxy_pass http://localhost:8000/;
        proxy_redirect / /aio/;
        proxy_set_header Host \$host;
        sub_filter 'href="/' 'href="/aio/';
        sub_filter 'src="/' 'src="/aio/';
        sub_filter 'action="' 'action="/aio';
        sub_filter "url('" "url('/aio";
        sub_filter 'value="" placeholder="nextcloud.yourdomain.com"' 'value="$NEXTCLOUD_DOMAIN"';
        sub_filter '"Submit domain"' '"Submit domain" id="domain-submit"';
        sub_filter 'name="talk"' 'name="talk" disabled';
        sub_filter 'needs ports 3478/TCP and 3478/UDP open/forwarded in your firewall/router' 'running the Talk container requires a public IP and this VM does not have one. It is still possible to use Talk in a limited capacity. Please consult the documentation for details';
        sub_filter '<body>' "<body onload=\"if(document.getElementById('domain-submit')) {document.getElementById('domain-submit').click()}; if (document.getElementById('talk') && document.getElementById('talk').checked) {document.getElementById('talk').checked = false; document.getElementById('options-form-submit').click()}\">";
        sub_filter_once off;
        sub_filter_types text/css;
    }

    location = /api/auth/getlogin {
        return 301 /aio/api/auth/getlogin\$is_args$args;
    }
    proxy_connect_timeout       7d;
    proxy_send_timeout          7d;
    proxy_read_timeout          7d;
    send_timeout                7d;
}
EOF

fi