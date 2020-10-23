#!/usr/bin/env bash
docker swarm init
docker network create traefik-net -d overlay
docker network create utilities -d overlay