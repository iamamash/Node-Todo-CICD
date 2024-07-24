# Stage 1: Build the application
FROM node:12.2.0-alpine as build

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Run the tests
RUN npm run test

# Stage 2: Run the application
FROM node:12-slim as runtime

# Set working directory
COPY --from=build app/ .

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["node","app.js"]

