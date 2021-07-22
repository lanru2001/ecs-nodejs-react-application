FROM node:14-alpine AS ui-build
WORKDIR /usr/src/app
COPY my-app/package*.json ./my-app/
COPY my-app/ ./my-app/
RUN cd my-app && npm install
RUN cd my-app && npm run build

FROM node:14-alpine AS server-build
WORKDIR /root/
COPY --from=ui-build /usr/src/app/my-app/build ./my-app/build
COPY api/package*.json ./api/
RUN cd api && npm install
COPY api/server.js ./api/

#Access the app at port 80
EXPOSE 80

CMD ["node", "./api/server.js"]
