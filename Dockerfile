# se basa en esa imagen de node y viene con /app
#FROM --platform=linux/arm64 node:19.2-alpine3.16
#dependencias de desarrollo 
FROM node:19.2-alpine3.16 as deps
# cd app
WORKDIR /app
# copia los archivos hacia el destino
COPY package.json ./
#instalar dependencias
RUN npm install

######nueva etapa cada vez que hay from
#dependencia de construccion y test
FROM node:19.2-alpine3.16 as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
# copia los archivos hacia el destino
COPY . .
RUN npm run test

######Dependencias de produccion
FROM node:19.2-alpine3.16 as prod-deps
WORKDIR /app
COPY package.json ./
RUN npm install --prod

################################
FROM node:19.2-alpine3.16 as runner
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY app.js ./
COPY tasks/ ./tasks
#Ejecutar un comando run de la imagen
CMD [ "node","app.js" ]


#Eliminar archivos y directorios no necesarios en prod
#RUN rm -rf tests && rm -rf node_modules 


#Desplegar en diferentes arquitecturas
#docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t paulguaman1505/cron-ticket:perro --push .