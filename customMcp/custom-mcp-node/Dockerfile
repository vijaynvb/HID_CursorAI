# Use official Node.js LTS image as the base
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the TypeScript code
RUN npm run build

# Use a smaller image for the runtime
FROM node:20-alpine AS runtime
WORKDIR /app

# Copy only the built code and node_modules from build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY package.json ./

# Expose port (change if your app uses a different port)
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]
