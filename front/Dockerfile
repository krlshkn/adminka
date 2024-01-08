FROM node:12-alpine as build
WORKDIR /app
#COPY package.json /app/package.json
COPY . /app
RUN npm install
#COPY . /app
#RUN npm install react-script@3.0.1 -g
RUN npm run build
FROM nginx:1.16.0-alpine
COPY --from=build /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
