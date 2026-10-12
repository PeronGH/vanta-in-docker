# vanta-in-docker

Runs the Vanta Device Monitor (Linux x64 agent) in a persistent, auto-restarting container.

## Usage

Get the enrollment token (base64 JSON with `AGENT_KEY`, `OWNER_EMAIL`, `REGION`) from Vanta, then:

```sh
VANTA_TOKEN=eyJBR0VOVF9LRVki... docker compose up -d
```

The token is only needed on first start; enrollment state lives in the `vanta` volume. Set `VANTA_HOSTNAME` to change the device name shown in Vanta (default `vanta-docker`).

```sh
docker compose exec vanta vanta-cli status   # check agent
docker compose down -v                       # remove, including enrollment
```

To upgrade the agent, bump `VANTA_VERSION` and `VANTA_SHA256` in the `Dockerfile` and run `docker compose up -d --build`.
