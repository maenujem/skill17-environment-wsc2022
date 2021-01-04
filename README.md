# Skill17-Environment

## How to create the Docker image
docker build -t esimage .

## How to use the built image
docker run -d --name esserver -p 80:80 -p 8000:8000 -p 3306:3306 -p 22:22 -p 4200:4200 esimage:latest
