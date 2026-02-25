# Stage 1: Build the Astro site with Bun
FROM oven/bun:1-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json bun.lock ./

# Install dependencies with frozen lockfile for reproducibility
RUN bun install --frozen-lockfile

# Copy source files
COPY . .

# Build the static site
RUN bun run build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built site from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Use non-root user for security
USER nginx

# Expose non-privileged port
EXPOSE 8080

# Health check for orchestration
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
