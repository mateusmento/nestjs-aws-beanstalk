FROM node:18.12.1-alpine as build
WORKDIR /usr/app
COPY --chown=node:node package*.json .
RUN npm install
COPY --chown=node:node . .
RUN npm run build

FROM node:18.12.1-alpine as prod
WORKDIR /usr/app
EXPOSE 8080
COPY --from=build --chown=node:node /usr/app/package*.json .
RUN npm ci --omit=dev
COPY --from=build --chown=node:node /usr/app/dist ./dist
CMD ["npm", "start"]
