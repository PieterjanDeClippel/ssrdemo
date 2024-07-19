# Stage 1: Compile and Build angular codebase

# Use official node image as the build image
FROM node:18 AS build_container

# Set the working directory
WORKDIR /app/src

# First only copy the package.json and package-lock.json
COPY package*.json ./

# Install all the dependencies
RUN npm ci

# Now copy over the other files
COPY . ./

# Generate the build of the application
RUN npm run build -- --configuration=production


# Stage 2: Serve app with nginx server

# Use official node image as the runtime image
FROM node:18

# Set the working directory
WORKDIR /usr/app

# Copy the build output to replace the default nginx contents.
COPY --from=build_container /app/src/dist/ssrdemo ./

# Expose port 80
EXPOSE 80
ENV PORT=80

CMD node /usr/app/ssrdemo/server/server.mjs
# ENTRYPOINT ["node", "/usr/local/ssrdemo/server/server.mjs"]

# docker build --tag 'ng-ssr-demo' .
# docker run -p 80 ng-ssr-demo
# Visit http://localhost:80
