## BUILD PHASE ##
FROM node:latest as builder
WORKDIR /app

COPY ./package.json ./package.json
COPY ./yarn.lock ./yarn.lock

RUN yarn install

COPY . .

RUN yarn run build

## RUN PHASE ##
FROM node:lts-alpine
WORKDIR /app

COPY --from=builder /app/package.json .
COPY --from=builder /app/yarn.lock .

# Build dependencies for production
RUN yarn install --production

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/dist ./dist

ENV NODE_ENV production
EXPOSE 3000

CMD ["yarn", "start"]