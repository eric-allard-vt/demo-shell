#FROM node:24-alpine
FROM node:24.11.1-alpine


# Install Docker CLI, bash, and zsh
RUN apk add --no-cache docker-cli bash zsh

# Set working directory
WORKDIR /usr/src/app

# Copy project files into the container
COPY . .

RUN chmod +x /usr/src/app/init-demo-env.sh
RUN cp /usr/src/app/.bashrc /root/.bashrc
RUN mkdir -p /usr/src/app/demo_files/exports

# Use init script to start the container
CMD ["/usr/src/app/init-demo-env.sh"]