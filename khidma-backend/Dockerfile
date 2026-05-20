# Base image
FROM node:20-alpine AS builder

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# Install app dependencies
RUN npm ci

# Bundle app source
COPY . .

# Build the application
RUN npm run build

# Production image
FROM node:20-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --only=production

COPY --from=builder /usr/src/app/dist ./dist

# Expose port
EXPOSE 3000

# Start the server
CMD ["node", "dist/main"]
