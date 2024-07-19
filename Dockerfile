# Stage 1: Compile and Build angular codebase

# Use official node image as the build image
FROM node:latest AS build_container

# Set the working directory
WORKDIR /usr/local/app

# Add the source code to app
COPY ./ /usr/local/app/

# Install all the dependencies
RUN npm install

# Generate the build of the application
RUN npm run build -- --configuration=production


# Stage 2: Serve app with nginx server

# Use official node image as the runtime image
FROM node:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build_container /usr/local/app/dist/ssrdemo /usr/local/ssrdemo

# Expose port 80
EXPOSE 80:5000
ENV PORT=5000

RUN node /usr/local/ssrdemo/server/server.mjs

# docker build --tag 'ng-ssr-demo' .
# docker run -p 80 ng-ssr-demo
# Visit http://localhost:80