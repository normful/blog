# Personal blog

- Built with [Zola](https://www.getzola.org) v0.15.3
- Deployed on Vercel at normful.com

# How-To: Deploy

1. `make`
2. `git push`

# Vercel workarounds used in this repo

## Problem: Vercel's `zola` version

I didn't use Vercel's Zola preset because it is hardcoded to use Zola 0.13.0. If this is upgraded later, I should change to using the preset again.

Attempting to set the `ZOLA_VERSION` Vercel env var only helped partially, but failed because Vercel's environment is missing required glib libraries.

Attempting to download, untar, and run a Zola release binary also failed, again because of the missing libraries.

Instead, I just run `zola build` locally and check in the generated `public` directory.

## Problem: Vercel's default lack of support for Git LFS

Workaround: https://github.com/vercel/community/discussions/49#discussioncomment-1395097

I set the Vercel build command (not the install command) to:

```
set -x && git remote add origin https://github.com/normful/blog.git && amazon-linux-extras install -y epel && yum install -y git-lfs && git lfs install && git lfs pull
```
