ARG NODE_VERSION=18.8

# Setup the build container.
FROM node:${NODE_VERSION}-alpine AS build

WORKDIR /home/node

# Install Git
RUN apk add git

# Install dependencies.
COPY package*.json .

RUN yarn install

# Copy the source files.
COPY src src
COPY tsconfig.json .

# Build the application.
RUN yarn build && yarn cache clean

# Setup the runtime container.
FROM node:${NODE_VERSION}-alpine

WORKDIR /home/node

# Copy the built application.
COPY --from=build /home/node /home/node

# Expose the service's port.
EXPOSE 3000

# Run the service.
CMD ["yarn", "run", "serve"]
