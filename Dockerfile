# se basa en esa imagen de node y viene con /app
#FROM --platform=linux/arm64 node:19.2-alpine3.16
FROM node:19.2-alpine3.16

# cd app
WORKDIR /app

# copia los archivos hacia el destino
COPY package.json ./

#instalar dependencias
RUN npm install

# copia los archivos hacia el destino
COPY . .

#realizar testing
RUN npm run test

#Eliminar archivos y directorios no necesarios en prod
RUN rm -rf tests && rm -rf node_modules 

# Instala solo las dependencias de prod
RUN npm install --prod

#Ejecutar un comando run de la imagen
CMD [ "node","app.js" ]

#Desplegar en diferentes arquitecturas
#docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t paulguaman1505/cron-ticket:perro --push .