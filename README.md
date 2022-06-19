# Docker Container with PHP 7 and Nginx on Alphine Linux
A simple docker container for PHP application development and production

## How to use
### 1. Create Docker Network
Create docker network for container. I don't use default network, because I can't configure it so much.
```sh
docker network create -d bridge main-network
```
### 2. Change Configuration
Edit "development.yml" or "production.yml" file. You can change any configuration you want like port, volume and network if you want. Don't forget to change your volume binding.
### 3. Docker Compose
Run and up. Use "development.yml" or "production.yml" as you need.
```sh
docker compose -f development.yml up -d
```

