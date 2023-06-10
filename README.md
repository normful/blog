# normful.com

[![Vercel Production Deployment](https://github.com/normful/blog/actions/workflows/deploy-prod-to-vercel.yaml/badge.svg)](https://github.com/normful/blog/actions/workflows/deploy-prod-to-vercel.yaml)

This is the code behind my blog at [normful.com](https://www.normful.com).

## How-To: Write new posts

1. Write in `.norg` files.
2. Start `zola serve` locally to preview additions.
3. Use `<Leader>mb` to "make blog" post. Keep exporting pages until there are no Zola warnings about broken links.
4. `git push` to deploy.
    
On push to the `main` branch, [this GitHub Action](https://github.com/normful/blog/actions) will build the pages with [Zola](https://www.getzola.org) to deploy them to Vercel with the [Vercel CLI](https://vercel.com/docs/cli).

## How-To: Update the papaya theme

```
git submodule update --remote
```

Ensure [config.toml](config.toml) is updated with any new theme config values.

## Git LFS

- Update `.gitattributes` if you use a new image format.
- If you cloned this repo without installing `git-lfs` first, run `git lfs fetch` and `git lfs checkout`.
