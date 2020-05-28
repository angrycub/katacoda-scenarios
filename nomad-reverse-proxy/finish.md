## Next steps

In this guide, you set up a reverse NIGNX proxy configured for the Nomad UI.
You also explored common configuration properties necessary to allow the Nomad
UI to work properly through a proxy—connection timeouts, proxy buffering,
WebSocket connections, and Origin header rewriting.

You can use these building blocks to configure your preferred proxy server
software to work with the Nomad UI. For further information about the NGINX
specific configuration highlighted in this guide, consult:

- [connection timeout][nginx-proxy-read-timeout]
- [proxy buffering][nginx-proxy-buffering]
- [WebSocket proxying][nginx-websocket-proxying]
- [session persistence][nginx-session-persistence]

Don't forget to visit [learn.hashicorp.com/nomad] for more Nomad guides.

[nginx-proxy-buffering]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering
[nginx-proxy-read-timeout]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout
[nginx-session-persistence]: https://nginx.org/en/docs/http/load_balancing.html#nginx_load_balancing_with_ip_hash
[nginx-websocket-proxying]: https://nginx.org/en/docs/http/websocket.html
[learn.hashicorp.com/nomad]: https://learn.hashicorp.com/nomad
