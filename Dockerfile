# 1. Build
FROM node:20-alpine AS builder
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY package*.json ./

RUN npm ci --prefer-offline --no-audit

COPY . .
RUN npm run build

# 2. Serve with nginx
FROM nginx:stable-alpine
RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html


# 3. Expose port
EXPOSE 80

# 4. Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
