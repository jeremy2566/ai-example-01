# syntax=docker/dockerfile:1

ARG NODE_VERSION=18.0.0
FROM node:${NODE_VERSION}-alpine

# Use production node environment by default
ENV NODE_ENV=production

WORKDIR /usr/src/app

# Download dependencies as a separate step to take advantage of Docker's caching
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=yarn.lock,target=yarn.lock \
    --mount=type=cache,target=/root/.yarn \
    yarn install --frozen-lockfile --production

# Run the application as a non-root user
USER node

# Copy the rest of the source files into the image
COPY . .

# Expose the port that the application listens on
EXPOSE 3001

# Run the application
CMD ["node", "index.js"]