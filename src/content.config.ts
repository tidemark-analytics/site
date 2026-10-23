import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    description: z.string().max(170),
    date: z.coerce.date(),
    updated: z.coerce.date().optional(),
    tag: z.string(),
    readingMinutes: z.number().optional(),
    order: z.number().default(100), // lists articles from the same day in this order

  }),
});

export const collections = { blog };
