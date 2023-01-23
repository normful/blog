# normful.com

[![Vercel Production Deployment](https://github.com/normful/blog/actions/workflows/deploy-prod-to-vercel.yaml/badge.svg)](https://github.com/normful/blog/actions/workflows/deploy-prod-to-vercel.yaml)

This is the code behind my blog at [normful.com](https://www.normful.com).

# Developing

1. `zola serve` locally to preview additions
2. `git push` to deploy
    
On push to the `main` branch, [this GitHub Action](https://github.com/normful/blog/actions) will build the pages with [Zola](https://www.getzola.org) to deploy them to Vercel with the [Vercel CLI](https://vercel.com/docs/cli).

# Notes to self

- Don't forget to update `.gitattributes` if using a new image format.
- You might need to run `git lfs fetch` and `git lfs checkout` if you previously cloned this repo without installing `git-lfs` first.
