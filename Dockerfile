# Step 1: Use official Node.js image for the build environment
FROM node:18-alpine AS build

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Step 4: Install Vue CLI globally
RUN npm install -g @vue/cli-service@latest

# Step 5: Install project dependencies
RUN npm install

# Step 6: Copy the rest of the project files into the container
COPY . .

# Step 7: Build the app for production
RUN npm run build

# Step 8: Use Nginx to serve the built app
FROM nginx:alpine

# Step 9: Copy the build output from the build stage to Nginx's web directory
COPY --from=build /app/dist /usr/share/nginx/html

# Step 10: Expose port 80 to serve the app
EXPOSE 80

# Step 11: Start Nginx in the foreground (no daemon mode)
CMD ["nginx", "-g", "daemon off;"]
