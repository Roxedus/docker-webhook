# Roxedus/docker-webhook

```yml
---
version: "2.1"
services:
  jellyfin:
    image: roxedus/webhook
    container_name: webhook
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - EXTRA_PARAM=-hotreload #optional
    volumes:
      - /path/to/config:/config
    ports:
      - 9000:9000
```

There is a default webhook configured in `/config/hooks/hooks.json`

`EXTRA_PARAM` is passed along to the application on startup, you use this to set additional cli arguments
