FROM node:15.5.1-alpine3.10

ENV PORT 3000
ENV PATH /usr/src/node_modules/.bin:$PATH

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Installing dependencies
COPY package*.json yarn.lock /usr/src/
RUN yarn

# Copying source files
COPY . /usr/src/app

EXPOSE 3000

# Running the app
CMD ["yarn", "dev"]
