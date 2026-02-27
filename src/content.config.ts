import { glob } from "astro/loaders";
import { defineCollection, z } from "astro:content";

const posts = defineCollection({
  loader: glob({ base: "./src/data/posts", pattern: "**/*.{md,mdx}" }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    updatedDate: z.coerce.date().optional(),
    tags: z.array(z.string()).default([]),
    draft: z.boolean().default(false),
    heroImage: z.string().optional(),
  }),
});

export const collections = { posts };
