FROM node:gallium-buster-slim

#node:16-alpine
#node:gallium-buster-slim

WORKDIR /jeffsbooks
EXPOSE 8088
CMD [ "node", "--experimental-modules", "server.mjs"]
COPY package.json /jeffsbooks
RUN yarn docker


COPY . .