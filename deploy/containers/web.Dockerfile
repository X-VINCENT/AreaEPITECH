FROM node:20.9-alpine3.18

# Install dependencies
RUN npm install -g npm@latest
RUN npm install -g serve

WORKDIR /app

COPY package*.json ./
RUN npm install

# Build
COPY . .
RUN npm run build

# Serve
EXPOSE 3000

CMD ["serve", "-s", "./dist"]
