cat > Caddyfile << END
{
	order replace after encode
}

END

if $IPV4 && ! $GATEWAY; then
  echo $NEXTCLOUD_DOMAIN:443 { >> Caddyfile
else
  echo $NEXTCLOUD_DOMAIN:80 { >> Caddyfile
fi

cat >> Caddyfile << "END"
	handle_path /aio* {
		replace {
			href="/ href="/aio/
			src="/ src="/aio/
			action=" action="/aio
			url(' url('/aio
			`value="" placeholder="nextcloud.yourdomain.com"` `value="$NEXTCLOUD_DOMAIN"`
END

if $IPV4; then
cat >> Caddyfile << "END"
			`"Submit domain"` `"Submit domain" id="domain-submit"`
			<body> `"<body onload="if(document.getElementById('domain-submit')) {document.getElementById('domain-submit').click()}">`
END
else
cat >> Caddyfile << "END"
			`name="talk"` `name="talk" disabled`
			`needs ports 3478/TCP and 3478/UDP open/forwarded in your firewall/router` `running the Talk container requires a public IP and this VM does not have one. It is still possible to use Talk in a limited capacity. Please consult the documentation for details`
			<body> `<body onload="if(document.getElementById('domain-submit')) {document.getElementById('domain-submit').click()}; if (document.getElementById('talk') && document.getElementById('talk').checked) {document.getElementById('talk').checked = false; document.getElementById('options-form-submit').click()}">`
END
fi

cat >> Caddyfile << "END"
		}
		reverse_proxy localhost:8000 {
			header_down Location "^/(.*)$" "/aio/$1"
			header_down Refresh "^/(.*)$" "/aio/$1"
		}
	}
	handle {
		redir / /aio
	}
}
END