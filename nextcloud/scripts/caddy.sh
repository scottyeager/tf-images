#!/bin/bash
export DOMAIN=$NEXTCLOUD_DOMAIN

if $IPV4 && ! $GATEWAY; then
  export PORT=443
else
  export PORT=80
fi

if $IPV4; then
  export BODY="\`<body onload=\"if (document.getElementById('domain-submit')) {document.getElementById('domain-submit').click()}\">\`"

else
  export BODY="\`<body onload=\"if (document.getElementById('domain-submit')) {document.getElementById('domain-submit').click()}; if (document.getElementById('talk') && document.getElementById('talk').checked) {document.getElementById('talk').checked = false; document.getElementById('options-form-submit').click()}\">\`"

  export REPLACEMENTS='			`name="talk"` `name="talk" disabled`
			`needs ports 3478/TCP and 3478/UDP open/forwarded in your firewall/router` `running the Talk container requires a public IP and this VM does not have one. It is still possible to use Talk in a limited capacity. Please consult the documentation for details`'
fi

caddy run --config /etc/caddy/Caddyfile