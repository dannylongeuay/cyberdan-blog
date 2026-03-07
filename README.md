# cyberdan-blog

Source for [blog.cyberdan.dev](https://blog.cyberdan.dev) — a personal technical blog built with Astro,
styled with the Catppuccin color palette, containerized with Docker + Nginx, and published to GHCR via GitHub Actions CI/CD.

## Tech Stack

- **Astro 5** — static site generator
- **Tailwind CSS v4** — utility-first styling with the Typography plugin
- **MDX** — blog content with component support
- **Catppuccin** — Latte (light) and Mocha (dark) color palettes
- **Bun** — JavaScript runtime and package manager
- **Nix Flakes** — reproducible dev environment
- **Docker + Nginx** — production container
- **GitHub Actions** — CI/CD with semantic-release

## Features

- Dark/light theme toggle with system preference detection and `localStorage` persistence
- MDX blog posts with automatic reading time estimates
- Tag-based categorization and filtering
- Responsive design with mobile navigation
- Automatic sitemap generation
- SEO meta tags (OpenGraph, Twitter cards)
- Shiki syntax highlighting with Catppuccin themes

## Project Structure

```
src/
├── components/
│   ├── Footer.astro
│   ├── FormattedDate.astro
│   ├── Header.astro
│   ├── PostCard.astro
│   ├── TagList.astro
│   └── ThemeToggle.astro
├── content.config.ts          # Collection schemas (Zod)
├── data/
│   └── posts/                 # MDX blog posts
├── layouts/
│   ├── BaseLayout.astro
│   └── BlogPostLayout.astro
├── pages/
│   ├── index.astro
│   ├── about.astro
│   ├── posts/
│   │   ├── index.astro
│   │   └── [...slug].astro
│   └── tags/
│       ├── index.astro
│       └── [tag].astro
└── styles/
    └── global.css

astro.config.mjs               # Astro config (MDX, sitemap, Shiki, Tailwind)
Dockerfile                      # Multi-stage build (Bun → Nginx)
nginx.conf                      # Production server config
flake.nix                       # Nix dev environment
```

## Getting Started

### Prerequisites

- [Bun](https://bun.sh/) — or [Nix](https://nixos.org/) with [direnv](https://direnv.net/)

### Setup

```sh
git clone https://github.com/cyberdan/cyberdan-blog.git
cd cyberdan-blog
bun install
bun run dev
```

### Alternative with Nix

```sh
direnv allow   # or: nix develop
bun install
bun run dev
```

### Available Scripts

| Command | Description |
|---|---|
| `bun run dev` | Start the dev server |
| `bun run build` | Production build to `dist/` |
| `bun run preview` | Preview the production build locally |

## Writing Content

Blog posts live in `src/data/posts/` as `.mdx` files. Each post requires frontmatter matching this schema:

```yaml
---
title: "Post Title"
description: "A short summary of the post."
pubDate: 2025-01-01
tags: ["astro", "docker"]
draft: false                  # optional, defaults to false
heroImage: "/images/hero.jpg" # optional
updatedDate: 2025-02-01       # optional
---
```

Posts with `draft: true` are excluded from the production build.

## Deployment

### Docker

```sh
docker build -t cyberdan-blog .
docker run -p 8080:8080 cyberdan-blog
```

The Dockerfile uses a multi-stage build: **Bun Alpine** compiles the site, then 
the static output is served by **Nginx Alpine**. The container runs as a non-root
user (`nginx`) on port 8080. The bundled `nginx.conf` adds security headers
(`X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, `Referrer-Policy`),
gzip compression, and aggressive caching for static assets.

### CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/release-and-publish.yml`) triggers on push to `main`:

1. **Release** — [semantic-release](https://github.com/semantic-release/semantic-release) determines the
next version from Conventional Commits and creates a GitHub release.
2. **Docker** — If a new version was published, builds a multi-platform image (`linux/amd64` + `linux/arm64`) and pushes it to GHCR.

Image tags: `latest`, full semver (`1.2.3`), `major.minor` (`1.2`), and `main-{sha}`.

### Container Registry

```sh
docker pull ghcr.io/cyberdan/cyberdan-blog:latest
```
