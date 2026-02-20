# Plan: Build CyberDan Blog (blog.cyberdan.dev)

## Context

The repo was previously a Hugo blog that was completely wiped clean. The goal is to rebuild it from scratch as a modern static blog for articles on DevOps, programming, and web development. Key requirements: static generation, code syntax highlighting, light/dark theme, responsive design.

## Technology Stack

- **Framework:** Astro (latest stable) - static site generator
- **Styling:** Tailwind CSS v4 + `@tailwindcss/typography` for article prose
- **Content:** MDX via `@astrojs/mdx`
- **Syntax highlighting:** Shiki (built into Astro) with dual themes (`github-light` / `github-dark`)
- **Package manager:** bun
- **Other:** `@astrojs/sitemap`, `reading-time` + `mdast-util-to-string` for reading time

## Directory Structure

```
cyberdan-blog/
├── astro.config.mjs
├── tsconfig.json
├── remark-reading-time.mjs
├── public/
│   ├── favicon.svg
│   └── robots.txt
├── src/
│   ├── content.config.ts          # Blog collection schema (Astro 5+ Content Layer)
│   ├── styles/global.css          # Tailwind imports, dark mode, code block styles
│   ├── layouts/
│   │   ├── BaseLayout.astro       # HTML shell, head, SEO, nav, footer, dark mode script
│   │   └── BlogPostLayout.astro   # Article wrapper with prose, date, tags, reading time
│   ├── components/
│   │   ├── Header.astro           # Responsive nav + mobile hamburger menu
│   │   ├── Footer.astro           # Copyright + GitHub link
│   │   ├── ThemeToggle.astro      # Light/dark toggle, persisted to localStorage
│   │   ├── PostCard.astro         # Card for post listings
│   │   ├── TagList.astro          # Clickable tag badges
│   │   └── FormattedDate.astro    # Date formatting
│   ├── pages/
│   │   ├── index.astro            # Home - intro + recent posts
│   │   ├── about.astro            # About page
│   │   ├── blog/
│   │   │   ├── index.astro        # All posts listing with tag filter links
│   │   │   └── [...slug].astro    # Individual post (dynamic route)
│   │   └── tags/
│   │       ├── index.astro        # All tags with counts
│   │       └── [tag].astro        # Posts filtered by tag
│   └── data/blog/
│       └── hello-world.mdx        # Sample post exercising multiple code languages
```

## Implementation Steps

### Step 1: Project scaffolding
- Scaffold Astro minimal template into the existing repo with `bun create astro`
- Install dependencies: `@astrojs/mdx`, `@astrojs/sitemap`, `tailwindcss`, `@tailwindcss/vite`, `@tailwindcss/typography`, `reading-time`, `mdast-util-to-string`
- Write `.gitignore` (dist/, .astro/, node_modules/)

### Step 2: Core configuration
- **`astro.config.mjs`**: site URL (`https://blog.cyberdan.dev`), static output, MDX + sitemap integrations, Shiki dual themes (`github-light`/`github-dark`), Tailwind as Vite plugin, remark reading time plugin
- **`tsconfig.json`**: extend `astro/tsconfigs/strict`
- **`remark-reading-time.mjs`**: custom remark plugin using `reading-time` + `mdast-util-to-string` to inject `minutesRead` into frontmatter

### Step 3: Content collection
- **`src/content.config.ts`**: Define `blog` collection with `glob()` loader. Schema: `title`, `description`, `pubDate`, `updatedDate?`, `tags` (default `[]`), `draft` (default `false`), `heroImage?`

### Step 4: Styling foundation
- **`src/styles/global.css`**:
  - `@import "tailwindcss"` + `@plugin "@tailwindcss/typography"`
  - `@custom-variant dark (&:where(.dark, .dark *))` for class-based dark mode
  - CSS custom properties for color tokens (light/dark variants)
  - Shiki dual-theme CSS: `.dark .astro-code span { color: var(--shiki-dark) !important; }`
  - Inline code styling, prose dark mode overrides

### Step 5: Components (leaf-first order)
1. **FormattedDate.astro** - renders `<time>` with locale-formatted date
2. **TagList.astro** - renders clickable tag pills linking to `/tags/[tag]`
3. **ThemeToggle.astro** - sun/moon icon button, toggles `.dark` class on `<html>`, persists to `localStorage`, listens for system preference changes
4. **Footer.astro** - copyright year, GitHub icon link, RSS link
5. **Header.astro** - site title, desktop nav links, ThemeToggle, mobile hamburger with collapsible menu, active link highlighting via `Astro.url.pathname`
6. **PostCard.astro** - card with title, date, description, tags, links to `/blog/[slug]`

### Step 6: Layouts
1. **BaseLayout.astro** - `<!doctype html>`, meta/SEO/OG tags, canonical URL, inline dark mode script (runs before paint to prevent FOUC), imports global.css, renders Header + `<main>` (max-w-3xl, flex-1) + Footer
2. **BlogPostLayout.astro** - extends BaseLayout, renders article header (title, date, updated date, reading time, tags), optional hero image, prose-wrapped `<slot />`

### Step 7: Pages
1. **`/` (index.astro)** - intro section with name/tagline + CTA buttons, recent 5 posts as PostCards
2. **`/blog` (blog/index.astro)** - all posts sorted by date, tag filter links at top
3. **`/blog/[slug]` (blog/[...slug].astro)** - `getStaticPaths()` from collection, `render()` for Content + remarkPluginFrontmatter.minutesRead
4. **`/about` (about.astro)** - static prose content about Daniel Longeuay
5. **`/tags` (tags/index.astro)** - all tags with post counts, sorted by frequency
6. **`/tags/[tag]` (tags/[tag].astro)** - posts filtered by tag

### Step 8: Content & static assets
- **`src/data/blog/hello-world.mdx`** - sample post with TypeScript, JavaScript, and Dockerfile code blocks to verify syntax highlighting
- **`public/favicon.svg`** - simple blue "D" favicon
- **`public/robots.txt`** - allow all + sitemap URL

## Key Design Decisions

- **Dark mode**: Class-based toggle (`.dark` on `<html>`). Inline `<script is:inline>` in `<head>` prevents FOUC. localStorage stores explicit preference; falls back to `prefers-color-scheme` media query.
- **Tailwind v4**: Uses Vite plugin (`@tailwindcss/vite`) instead of the old `@astrojs/tailwind` integration. CSS-first config via `@custom-variant` and `@plugin` directives.
- **Shiki dual themes**: Configured in `astro.config.mjs` as `themes: { light: "github-light", dark: "github-dark" }`. CSS switches via `--shiki-dark` custom properties when `.dark` is active.
- **Content Layer API**: Astro 5+ `glob()` loader in `src/content.config.ts`. Post IDs are auto-derived from filenames.
- **Responsive**: Mobile-first with Tailwind breakpoints. Header collapses to hamburger on `sm:` breakpoint. Content area is `max-w-3xl` with horizontal padding.

## Verification

1. `bun run dev` - start dev server, verify:
   - Home page renders with intro + sample post card
   - Blog listing shows the sample post
   - Individual post renders with syntax highlighting (multiple languages)
   - Dark mode toggle works without flash on page load
   - Mobile hamburger menu opens/closes
   - Tags link to filtered views
   - About page renders
2. `bun run build` - verify static build completes without errors, check `dist/` output
3. `bun run preview` - serve the built site and verify all pages work
