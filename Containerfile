# Static resume site, served by Caddy on :8080 behind the shared edge proxy.
FROM caddy:2-alpine

COPY site.Caddyfile /etc/caddy/Caddyfile
COPY index.html profile.jpg /srv/

EXPOSE 8080
