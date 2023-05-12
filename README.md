# normful.com

[![Vercel Production Deployment](https://github.com/normful/blog/actions/workflows/deploy-prod-to-vercel.yaml/badge.svg)](https://github.com/normful/blog/actions/workflows/deploy-prod-to-vercel.yaml)

This is the code behind my blog at [normful.com](https://www.normful.com).

# Developing

1. Start `zola serve` locally to preview additions. Watch it for errors.
2. Write source in `.norg` files.
3. Use `,mb` (English) or `,mjb` (Japanese) to convert Neorg to Markdown. If any internal links are broken, `zola serve` output will print errors. Keep exporting linked pages until there are no Zola errors.
4. `git push` to deploy.
    
On push to the `main` branch, [this GitHub Action](https://github.com/normful/blog/actions) will build the pages with [Zola](https://www.getzola.org) to deploy them to Vercel with the [Vercel CLI](https://vercel.com/docs/cli).

## How-To: Update the papaya theme

```
git submodule update --remote
```

# Notes to self

- Don't forget to update `.gitattributes` if using a new image format.
- You might need to run `git lfs fetch` and `git lfs checkout` if you previously cloned this repo without installing `git-lfs` first.
