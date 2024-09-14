# Use a fully alpine based solution, rather than the debian
# container I ended up with when I imported node:20-slim.
# 2024-09-01 12:51

FROM node:20-alpine

# As far as I can tell, this alpine version of node has yarn
# installed, so I don't need to do that step.

EXPOSE 8600

WORKDIR /root/retro-env-can-weather-chan
RUN apk add --no-cache git tini

RUN git clone https://github.com/Forceh91/retro-env-can-weather-chan ./

# reduce the size of the resulting container by not including the cache files
RUN yarn install --frozen-lockfile && yarn cache clean
RUN yarn build:display && yarn cache clean

# Using tini ensures ctrl+c works.
ENTRYPOINT ["tini", "--"]
CMD [ "yarn", "start" ]
