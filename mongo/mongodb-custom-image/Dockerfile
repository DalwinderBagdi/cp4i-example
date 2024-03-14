FROM --platform=linux/amd64 mongo:latest

# Copy the MongoDB initialization script to the Docker image
COPY init-mongo.js /docker-entrypoint-initdb.d/
