# Use the official Node.js 20 image as the base image for a smaller image size

FROM node:20-slim
WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nodejs && \
    chown -R nodejs:nodejs /app

USER nodejs

#test the health of the application by making a request to the /health endpoint
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "executable" ]EALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

EXPOSE 3000

# Use npm start instead of hardcoding the file
CMD ["npm", "start"]