FROM node:17 as builder

COPY package.json ./
COPY yarn.lock ./
RUN yarn install
COPY src src
COPY public public
RUN yarn build

FROM nginx
COPY --from=builder dist /usr/share/nginx/html/