# https://tariqul-islam-rony.medium.com/angular-learning-part3-7a7c3708b480

# Stage 1: Build an Angular Docker Image
FROM node:16.10 as build
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY . /app
ARG configuration=production
RUN npm run build -- --outputPath=./dist/out --configuration $configuration
# Stage 2, use the compiled app, ready for production with Nginx
FROM nginx
COPY --from=build /app/dist/out/ /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
